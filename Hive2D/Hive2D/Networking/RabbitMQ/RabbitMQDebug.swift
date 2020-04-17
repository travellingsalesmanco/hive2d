//
//  RabbitMQDebug.swift
//  Hive2D
//
//  Created by John Phua on 17/04/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import RMQClient

class RabbitMQDebug: NSObject, RMQConnectionDelegate {
    func connection(_ connection: RMQConnection!, failedToConnectWithError error: Error!) {
        print("FAILED TO CONNECT: ", error!)
    }

    func connection(_ connection: RMQConnection!, disconnectedWithError error: Error!) {
        print("DISCONNECTED: ", error!)
    }

    func willStartRecovery(with connection: RMQConnection!) {
    }

    func startingRecovery(with connection: RMQConnection!) {
    }

    func recoveredConnection(_ connection: RMQConnection!) {
    }

    func channel(_ channel: RMQChannel!, error: Error!) {
        print("CHANNEL ERROR: ", error!)
    }
}
