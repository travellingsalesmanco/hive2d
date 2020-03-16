//
//  JoinGameModalViewController.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 16/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import UIKit

class JoinGameModalViewController: UIViewController {
    @IBOutlet weak var roomCode: UITextField!

    @IBAction func handleDismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func joinGame(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
