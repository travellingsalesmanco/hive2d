//
//  ChooseNameModalViewController.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import UIKit

class ChooseNameModalViewController: UIViewController {
    weak var delegate: ChooseNameModalDelegate?
    @IBOutlet private var playerName: UITextField!

    @IBAction private func handleDismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func handleSubmit(_ sender: UIButton) {
        guard let name = playerName.text else {
            return
        }
        dismiss(animated: true, completion: nil)
        delegate?.didSubmit(name: name)
    }
}

protocol ChooseNameModalDelegate: AnyObject {
    func didSubmit(name: String)
}
