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
    @IBOutlet private var terrainSelector: UISegmentedControl!
    @IBOutlet private var roomCode: UILabel!
    @IBOutlet private var playerList: [UILabel]!
    @IBOutlet private var startGameButton: UIButton!

    private var mapSize = MapSize.small
    private var resourceRate = ResourceRate.normal

    private var lobbyNetworking: LobbyNetworking?
    private var lobby: Lobby?
    private var me: GamePlayer!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let isHost = lobby?.isHost(playerId: me.id) ?? false
        startGameButton.isHidden = !isHost
        refreshLobby()
    }

    // Remove reference for lobby objects when out of view
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        lobbyNetworking = nil
        lobby = nil
    }

    func initLobby(lobby: Lobby, me: GamePlayer, lobbyNetworking: LobbyNetworking) {
        self.lobby = lobby
        self.me = me
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

    @IBAction private func selectTerrain(_ sender: UISegmentedControl) {
        guard var lobby = lobby else {
            return
        }

        switch terrainSelector.selectedSegmentIndex {
        case 0:
            lobby.settings.terrainType = .mineral
        case 1:
            lobby.settings.terrainType = .letter
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
        switch lobby.settings.terrainType {
        case .mineral:
            terrainSelector.selectedSegmentIndex = 0
        case .letter:
            terrainSelector.selectedSegmentIndex = 1
        }
        refreshPlayerList()
    }

    private func refreshPlayerList() {
        guard let lobby = lobby else {
            return
        }
        for (index, player) in lobby.players.enumerated() {
            playerList[index].text = player.name
        }

        for index in lobby.players.count ..< playerList.count {
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

        gameViewController.setGameConfig(lobby: lobby, me: me, gameNetworking: networking)
        self.navigationController?.pushViewController(gameViewController, animated: true)
    }
}
