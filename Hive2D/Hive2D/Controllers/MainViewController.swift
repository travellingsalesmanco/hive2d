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

    private var lobbyFinder: LobbyFinder
    private var lobbyAction: LobbyAction = .create
    private var roomCode: String?

    required init?(coder aDecoder: NSCoder) {
        lobbyFinder = FirebaseLobbyFinder()
        super.init(coder: aDecoder)
        lobbyFinder.delegate = self
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

    private func pushLobbyViewController(lobby: Lobby, lobbyNetworking: LobbyNetworking) {
        guard let lobbyViewController = storyboard?.instantiateViewController(identifier: Constants.StoryBoardIds.lobbyViewController) as? LobbyViewController else {
            return
        }
        lobbyViewController.initLobby(lobby: lobby, lobbyNetworking: lobbyNetworking)
        self.navigationController?.pushViewController(lobbyViewController, animated: true)
    }
}

extension MainViewController: ChooseNameModalDelegate {
    func didSubmit(name: String) {
        let player = GamePlayer(name: name)
        switch lobbyAction {
        case .create:
            startAnimating(message: Constants.LobbyMessages.createLobby,
                           messageFont: Constants.LobbyMessages.fontSize,
                           type: .ballClipRotateMultiple)
            lobbyFinder.createLobby(host: player)
        case .join:
            guard let roomCode = roomCode else { return }
            startAnimating(message: Constants.LobbyMessages.joinLobby,
                           messageFont: Constants.LobbyMessages.fontSize,
                           type: .ballClipRotateMultiple)

            lobbyFinder.joinLobby(id: roomCode, player: player)
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
