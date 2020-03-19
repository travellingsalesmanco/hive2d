//
//  LobbyViewController.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 15/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import UIKit

class LobbyViewController: UIViewController {
    @IBOutlet private var mapSizeSelector: UISegmentedControl!
    @IBOutlet private var resourceRateSelector: UISegmentedControl!
    @IBOutlet private var roomCode: UILabel!
    @IBOutlet private var playerList: [UILabel]!
    @IBOutlet private var startGameButton: UIButton!

    private var mapSize = MapSize.small
    private var resourceRate = ResourceRate.normal

    private var lobbyNetworking: LobbyNetworking?
    private var lobby: Lobby?
    private var ownId: String?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.ownId = UserAuthState.shared.get()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let ownId = self.ownId else {
            return
        }
        let isHost = lobby?.isHost(playerId: ownId) ?? false
        startGameButton.isHidden = !isHost
        refreshLobby()
    }

    // Remove reference for lobby objects when out of view
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        lobbyNetworking = nil
        lobby = nil
    }

    func initLobby(lobby: Lobby, lobbyNetworking: LobbyNetworking) {
        self.lobby = lobby
        self.lobbyNetworking = lobbyNetworking
        self.lobbyNetworking?.delegate = self
    }

    @IBAction private func returnToMainView(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction private func selectMapSize(_ sender: UISegmentedControl) {
        guard var lobby = lobby else {
            return
        }

        switch mapSizeSelector.selectedSegmentIndex {
        case 0:
            lobby.settings.mapSize = .small
        case 1:
            lobby.settings.mapSize = .medium
        case 2:
            lobby.settings.mapSize = .large
        default:
            break
        }

        lobbyNetworking?.updateLobby(lobby)
    }

    @IBAction private func selectResourceRate(_ sender: UISegmentedControl) {
        guard var lobby = lobby else {
            return
        }

        switch resourceRateSelector.selectedSegmentIndex {
        case 0:
            lobby.settings.resourceRate = .normal
        case 1:
            lobby.settings.resourceRate = .fast
        default:
            break
        }

        lobbyNetworking?.updateLobby(lobby)
    }

    private func refreshLobby() {
        guard let lobby = lobby else {
            return
        }

        // Checks that view is loaded before attempting to refresh
        if !isViewLoaded {
            return
        }

        startGameButton.isEnabled = lobby.gameCanStart()
        startGameButton.alpha = startGameButton.isEnabled
            ? Constants.UI.buttonEnabledAlpha : Constants.UI.buttonDisabledAlpha
        roomCode.text = lobby.code
        mapSizeSelector.selectedSegmentIndex = lobby.settings.mapSize.rawValue
        resourceRateSelector.selectedSegmentIndex = lobby.settings.resourceRate.rawValue
        refreshPlayerList()
    }

    private func refreshPlayerList() {
        lobby?.players.values.enumerated().forEach { arg in
            let (index, element) = arg
            playerList[index].text = element.name
        }

        for index in (lobby?.players.count ?? 0) ..< playerList.count {
            playerList[index].text = Constants.LobbyMessages.noPlayer
        }
    }

    @IBAction private func startGame(_ sender: UIButton) {
        guard let lobby = lobby, lobby.gameCanStart() else {
            return
        }

        lobbyNetworking?.start()
    }
}

extension LobbyViewController: LobbyNetworkingDelegate {
    func lobbyDidUpdate(lobby: Lobby) {
        self.lobby = lobby
        refreshLobby()
    }

    func lobbyUpdateFailed() {
    }

    func gameStarted(lobby: Lobby, networking: GameNetworking) {
        let viewController = storyboard?.instantiateViewController(identifier: Constants.StoryBoardIds.gameVC)
        guard let gameViewController = viewController as? GameViewController else {
            return
        }

        guard let lobby = self.lobby else {
            return
        }

        gameViewController.setGameConfig(lobby: lobby, gameNetworking: networking)
        self.navigationController?.pushViewController(gameViewController, animated: true)
    }
}
