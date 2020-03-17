//
//  LobbyViewController.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 15/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import UIKit

class LobbyViewController: UIViewController {
    @IBOutlet weak var mapSizeSelector: UISegmentedControl!
    @IBOutlet weak var resourceRateSelector: UISegmentedControl!
    @IBOutlet weak var roomCode: UILabel!
    @IBOutlet var playerList: [UILabel]!

    private var mapSize = MapSize.small
    private var resourceRate = ResourceRate.normal

    private var lobbyNetworking: LobbyNetworking
    private var lobby: Lobby?

    required init?(coder aDecoder: NSCoder) {
        lobbyNetworking = FirebaseLobby()
        super.init(coder: aDecoder)
        lobbyNetworking.lobbyDelegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        roomCode.text = lobby?.code
        refreshPlayerList()
    }

    @IBAction func returnToMainView(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func selectMapSize(_ sender: UISegmentedControl) {
        switch mapSizeSelector.selectedSegmentIndex {
        case 0: mapSize = .small
        case 1: mapSize = .medium
        case 2: mapSize = .large
        default: break
        }
    }

    @IBAction func selectResourceRate(_ sender: UISegmentedControl) {
        switch resourceRateSelector.selectedSegmentIndex {
        case 0: resourceRate = .normal
        case 1: resourceRate = .fast
        default: break
        }
    }

    func initLobby(lobby: Lobby) {
        self.lobby = lobby
    }

    private func refreshPlayerList() {
        lobby?.players.enumerated().forEach { (arg) in
            let (index, element) = arg
            playerList[index].text = element.name
        }

        for index in (lobby?.players.count ?? 0) ..< playerList.count {
            playerList[index].text = Constants.LobbyMessages.noPlayer
        }
    }

    @IBAction func startGame(_ sender: UIButton) {
        // Validation for min. number of players
    }
}

extension LobbyViewController: LobbyNetworkingDelegate {
    func lobbyCreated(lobby: Lobby) {
        return
    }

    func lobbyCreationFailed() {
        return
    }

    func lobbyJoined(lobby: Lobby) {
        return
    }

    func lobbyJoinFailed() {
        return
    }

    func lobbyDidUpdate(lobby: Lobby) {
        self.lobby = lobby
        refreshPlayerList()
    }

    func lobbyUpdateFailed() {
        return
    }

    func gameStarted() {
        return
    }
}
