//
//  JoinGameModalViewController.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 16/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import UIKit

class JoinGameModalViewController: UIViewController {
    weak var delegate: JoinGameModalDelegate?
    @IBOutlet private var roomCode: UITextField!

    @IBAction private func handleDismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func joinGame(_ sender: UIButton) {
        guard let code = roomCode.text else {
            return
        }
        dismiss(animated: true, completion: nil)
        delegate?.didJoinGame(roomCode: code)
    }
}

protocol JoinGameModalDelegate: AnyObject {
    func didJoinGame(roomCode: String)
}
