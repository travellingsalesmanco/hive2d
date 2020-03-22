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
    private enum LobbyAction {
        case create
        case join
    }

    private var userAuth: UserAuth
    private var lobbyFinder: LobbyFinder
    private var lobbyAction: LobbyAction = .create
    private var roomCode: String?
    private var player: GamePlayer!

    required init?(coder aDecoder: NSCoder) {
        lobbyFinder = FirebaseLobbyFinder()
        userAuth = FirebaseUserAuth()
        super.init(coder: aDecoder)

        lobbyFinder.delegate = self
        userAuth.logIn()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    @IBAction private func createLobby(_ sender: UIButton) {
        lobbyAction = .create
        presentChooseNameModal()
    }

    @IBAction private func joinGame(_ sender: UIButton) {
        lobbyAction = .join
        presentJoinGameModal()
    }

    private func presentChooseNameModal() {
        let viewController = storyboard?.instantiateViewController(identifier: Constants.StoryBoardIds.chooseNameModal)
        guard let chooseNameModal = viewController as? ChooseNameModalViewController else {
            return
        }

        chooseNameModal.modalPresentationStyle = .overCurrentContext
        chooseNameModal.delegate = self
        present(chooseNameModal, animated: true, completion: nil)
    }

    private func presentJoinGameModal() {
        let viewController = storyboard?.instantiateViewController(identifier: Constants.StoryBoardIds.joinGameModal)
        guard let joinGameModal = viewController as? JoinGameModalViewController else {
            return
        }

        joinGameModal.modalPresentationStyle = .overCurrentContext
        joinGameModal.delegate = self
        present(joinGameModal, animated: true, completion: nil)
    }

    private func pushLobbyViewController(lobby: Lobby, lobbyNetworking: LobbyNetworking) {
        let viewController = storyboard?.instantiateViewController(identifier: Constants.StoryBoardIds.lobbyVC)
        guard let lobbyViewController = viewController as? LobbyViewController else {
            return
        }
        lobbyViewController.initLobby(lobby: lobby, me: player, lobbyNetworking: lobbyNetworking)
        self.navigationController?.pushViewController(lobbyViewController, animated: true)
    }
}

extension MainViewController: ChooseNameModalDelegate {
    func didSubmit(name: String) {
        guard let playerId = UserAuthState.shared.get() else {
            return
        }

        player = GamePlayer(name: name, id: playerId)
        switch lobbyAction {
        case .create:
            startAnimating(message: Constants.LobbyMessages.createLobby,
                           messageFont: Constants.LobbyMessages.fontSize,
                           type: .ballClipRotateMultiple)
            lobbyFinder.createLobby(me: player)
        case .join:
            guard let roomCode = roomCode else {
                return
            }
            startAnimating(message: Constants.LobbyMessages.joinLobby,
                           messageFont: Constants.LobbyMessages.fontSize,
                           type: .ballClipRotateMultiple)

            lobbyFinder.joinLobby(code: roomCode, me: player)
        }
    }
}

extension MainViewController: JoinGameModalDelegate {
    func didJoinGame(roomCode: String) {
        self.roomCode = roomCode
        presentChooseNameModal()
    }
}

extension MainViewController: LobbyFinderDelegate {
    func lobbyCreated(lobby: Lobby, networking: LobbyNetworking) {
        stopAnimating()
        pushLobbyViewController(lobby: lobby, lobbyNetworking: networking)
    }

    func lobbyCreationFailed() {
        stopAnimating()
    }

    func lobbyJoined(lobby: Lobby, networking: LobbyNetworking) {
        stopAnimating()
        pushLobbyViewController(lobby: lobby, lobbyNetworking: networking)
    }

    func lobbyJoinFailed() {
        stopAnimating()
    }
}
