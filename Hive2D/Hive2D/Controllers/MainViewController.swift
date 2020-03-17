//
//  MainViewController.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 15/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class MainViewController: UIViewController, NVActivityIndicatorViewable {
    enum LobbyAction {
        case create
        case join
    }

    private var lobbyNetworking: LobbyNetworking
    private var lobbyAction: LobbyAction = .create
    private var roomCode: String?

    required init?(coder aDecoder: NSCoder) {
        lobbyNetworking = FirebaseLobby()
        super.init(coder: aDecoder)
        lobbyNetworking.lobbyDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    @IBAction func createLobby(_ sender: UIButton) {
        lobbyAction = .create
        presentChooseNameModal()
    }

    @IBAction func joinGame(_ sender: UIButton) {
        lobbyAction = .join
        presentJoinGameModal()
    }

    private func presentChooseNameModal() {
        guard let chooseNameModal = storyboard?.instantiateViewController(identifier: Constants.StoryBoardIds.chooseNameModal) as? ChooseNameModalViewController else {
            return
        }

        chooseNameModal.modalPresentationStyle = .overCurrentContext
        chooseNameModal.delegate = self
        present(chooseNameModal, animated: true, completion: nil)
    }

    private func presentJoinGameModal() {
        guard let joinGameModal = storyboard?.instantiateViewController(identifier: Constants.StoryBoardIds.joinGameModal) as? JoinGameModalViewController else {
            return
        }

        joinGameModal.modalPresentationStyle = .overCurrentContext
        joinGameModal.delegate = self
        present(joinGameModal, animated: true, completion: nil)
    }

    private func pushLobbyViewController(lobby: Lobby) {
        guard let lobbyViewController = storyboard?.instantiateViewController(identifier: Constants.StoryBoardIds.lobbyViewController) as? LobbyViewController else {
            return
        }
        lobbyViewController.initLobby(lobby: lobby)
        self.navigationController?.pushViewController(lobbyViewController, animated: true)
    }
}

extension MainViewController: ChooseNameModalDelegate {
    func didSubmit(name: String) {
        let player = LobbyPlayer(name: name)
        switch lobbyAction {
        case .create:
            startAnimating(message: Constants.LobbyMessages.createLobby,
                           messageFont: Constants.LobbyMessages.fontSize,
                           type: .ballClipRotateMultiple)
            lobbyNetworking.createLobby(host: player)
        case .join:
            guard let roomCode = roomCode else { return }
            startAnimating(message: Constants.LobbyMessages.joinLobby,
                           messageFont: Constants.LobbyMessages.fontSize,
                           type: .ballClipRotateMultiple)

            lobbyNetworking.joinLobby(id: roomCode, player: player)
        }
    }
}

extension MainViewController: JoinGameModalDelegate {
    func didJoinGame(roomCode: String) {
        self.roomCode = roomCode
        presentChooseNameModal()
    }
}

extension MainViewController: LobbyNetworkingDelegate {
    func lobbyCreated(lobby: Lobby) {
        stopAnimating()
        pushLobbyViewController(lobby: lobby)
    }

    func lobbyCreationFailed() {
        stopAnimating()
    }

    func lobbyJoined(lobby: Lobby) {
        stopAnimating()
        pushLobbyViewController(lobby: lobby)
    }

    func lobbyJoinFailed() {
        stopAnimating()
    }

    func lobbyDidUpdate(lobby: Lobby) {
        return
    }

    func lobbyUpdateFailed() {
        return
    }

    func gameStarted() {
        return
    }
}
