//
//  SettingsModalViewController.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 16/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import UIKit

class SettingsModalViewController: UIViewController {
    @IBOutlet private var bgmSelector: UISegmentedControl!
    private var musicEnabled = true

    @IBAction private func handleDismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func toggleBackgroundMusic(_ sender: UISegmentedControl) {
        switch bgmSelector.selectedSegmentIndex {
        case 0:
            musicEnabled = true
        case 1:
            musicEnabled = false
        default:
            break
        }
    }
}
