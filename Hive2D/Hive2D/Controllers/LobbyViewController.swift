//
//  LobbyViewController.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 15/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import UIKit

class LobbyViewController: UIViewController {
    enum MapSize {
        case small
        case medium
        case large
    }

    enum ResourceRate {
        case normal
        case fast
    }

    @IBOutlet weak var mapSizeSelector: UISegmentedControl!
    @IBOutlet weak var resourceRateSelector: UISegmentedControl!
    @IBOutlet weak var roomCode: UILabel!
    @IBOutlet var playerList: [UILabel]!

    private var mapSize = MapSize.small
    private var resourceRate = ResourceRate.normal
    // TODO: Player struct for other details e.g. isHost?
    private var players = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: Replace when integrating
        roomCode.text = "Corona"
        players.append("Adam")
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

    private func refreshPlayerList() {
        players.enumerated().forEach { (arg) in
            let (index, element) = arg
            playerList[index].text = element
        }

        for index in players.count ..< playerList.count {
            playerList[index].text = "Nobody :("
        }
    }

    @IBAction func startGame(_ sender: UIButton) {
        // Validation for min. number of players
    }
}
