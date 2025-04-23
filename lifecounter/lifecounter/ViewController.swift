//
//  ViewController.swift
//  lifecounter
//
//  Created by 郭家玮 on 4/21/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loserLabel: UILabel!
    
    @IBOutlet weak var mainContainerStack: UIStackView!
    @IBOutlet weak var playerContainerStack: UIStackView!
    @IBOutlet weak var addPlayerButton: UIButton!
    
    var players: [PlayerView] = []
    var historyLog: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetGame(self)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { _ in
            let isLandscape = size.width > size.height
            self.mainContainerStack.axis = isLandscape ? .vertical : .vertical
            self.playerContainerStack.axis = isLandscape ? .horizontal : .vertical
        })
    }

    
    func addPlayer(name: String) {
        let nib = UINib(nibName: "PlayerView", bundle: nil)
        guard let playerView = nib.instantiate(withOwner: nil, options: nil).first as? PlayerView else { return }

        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.nameLabel.text = name
        
        playerView.checkForLoss = { [weak self] in
            self?.checkForLoser()
        }
        
        playerView.onLifeChangedWithText = { [weak self] text in
            self?.historyLog.append(text)
            self?.addPlayerButton.isEnabled = false
        }

        players.append(playerView)
        playerContainerStack.addArrangedSubview(playerView)
    }


    func checkForLoser() {
        let losers = players.filter { $0.life <= 0 }
        if losers.count == players.count - 1 {
            let winner = players.first { $0.life > 0 }
            loserLabel.text = "\(winner?.nameLabel.text ?? "Unknown") wins!"
            loserLabel.alpha = 1
        } else {
            loserLabel.alpha = 0
        }
    }

    @IBAction func addPlayerButtonTapped(_ sender: UIButton) {
        guard players.count < 8 else { return }
        let nextPlayerIndex = players.count + 1
        addPlayer(name: "Player \(nextPlayerIndex)")
        
        if players.count == 8 {
            sender.isEnabled = false
        }
    }
    
    @IBAction func resetGame(_ sender: Any) {
        for player in players {
            player.removeFromSuperview()
        }
        players.removeAll()

        for i in 1...4 {
            addPlayer(name: "Player \(i)")
        }

        loserLabel.alpha = 0
        addPlayerButton.isEnabled = true
    }
}
