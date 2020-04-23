//
//  RabbitMQGame.swift
//  Hive2D
//
//  Created by John Phua on 17/04/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import RMQClient

class RabbitMQGame: GameNetworking {
    var gameActionQueue: GameActionQueue
    // RabbitMQ channels
    private var writeChannel: RMQChannel
    private var readChannel: RMQChannel

    // Used to send messages
    private var wExchange: RMQExchange
    // Used to receive messages
    private var queue: RMQQueue
    private var subscription: RMQConsumer?
    // Sent when "disconnected"
    private var disconnectAction: GameAction?

    init(gameId: String) {
        let conn = RabbitMQConnection.shared.conn

        readChannel = conn.createChannel()
        writeChannel = conn.createChannel()

        let rExchange = readChannel.fanout(gameId, options: .autoDelete)
        wExchange = writeChannel.fanout(gameId, options: .autoDelete)

        queue = readChannel.queue("", options: .exclusive)
        queue.bind(rExchange)

        gameActionQueue = GameActionQueue(gameId: gameId)
        checkSetup()

        subscription = queue.subscribe({ [weak self] message in
            guard let self = self else {
                return
            }
            self.receiveGameAction(message)
        })
    }

    private func checkSetup() {
        var done = false

        while !done {
            wExchange.publish("test".data(using: .utf8))
            queue.pop({ _ in done = true })
            sleep(1)
        }
    }

    deinit {
        if let disconnectAction = disconnectAction {
            sendGameAction(disconnectAction)
        }

        subscription?.cancel()
        writeChannel.close()
        readChannel.close()
    }

    func sendGameAction(_ action: GameAction) {
        guard let codableAction = CodableGameAction(action) else {
            return
        }

        let codedAction = try? JSONEncoder().encode(codableAction)
        wExchange.publish(codedAction)
    }

    func onDisconnectSend(_ action: GameAction) {
        disconnectAction = action
    }

    private func receiveGameAction(_ message: RMQMessage) {
        guard let action = try? JSONDecoder().decode(CodableGameAction.self, from: message.body) else {
            return
        }
        gameActionQueue.enqueue(action: action.gameAction)
    }
}
