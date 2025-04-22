//
//  ViewController.swift
//  lifecounter
//
//  Created by 郭家玮 on 4/21/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var p1HealthLabel: UILabel!
    @IBOutlet weak var p2HealthLabel: UILabel!
    @IBOutlet weak var loserLabel: UILabel!
    
    @IBOutlet weak var mainContainerStack: UIStackView!
    @IBOutlet weak var playerContainerStack: UIStackView!
    
    var p2HealthCount = 20
    var p1HealthCount = 20
    
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

    
    func updateP1Label() {
        p1HealthLabel.text = "\(p1HealthCount)"
        checkForLoser()
    }
    
    func updateP2Label() {
        p2HealthLabel.text = "\(p2HealthCount)"
        checkForLoser() 
    }
    
    func checkForLoser() {
        if p1HealthCount <= 0 {
            loserLabel.text = "Player 1 LOSES!"
            loserLabel.alpha = 1
        } else if p2HealthCount <= 0 {
            loserLabel.text = "Player 2 LOSES!"
            loserLabel.alpha = 1
        } else {
            loserLabel.alpha = 0
        }
    }

    @IBAction func p2minus1(_ sender: Any) {
        if p2HealthCount > 0 {
            p2HealthCount = max(p2HealthCount - 1, 0)
            updateP2Label()
        }
    }
    
    @IBAction func p2minus5(_ sender: Any) {
        if p2HealthCount > 0 {
            p2HealthCount = max(p2HealthCount - 5, 0)
            updateP2Label()
        }
    }
    
    
    @IBAction func p2add1(_ sender: Any) {
        p2HealthCount += 1
        updateP2Label()
    }
    
    @IBAction func p2add5(_ sender: Any) {
        p2HealthCount += 5
        updateP2Label()
    }
    
    @IBAction func p1minus1(_ sender: Any) {
        if p1HealthCount > 0 {
            p1HealthCount = max(p1HealthCount - 1, 0)
            updateP1Label()
        }
    }
    
    @IBAction func p1minus5(_ sender: Any) {
        if p1HealthCount > 0 {
            p1HealthCount = max(p1HealthCount - 5, 0)
            updateP1Label()
        }
    }
    @IBAction func p1add1(_ sender: Any) {
        p1HealthCount += 1
        updateP1Label()
    }
    @IBAction func p1add5(_ sender: Any) {
        p1HealthCount += 5
        updateP1Label()
    }
    
    @IBAction func resetGame(_ sender: Any) {
        p1HealthCount = 20
        p2HealthCount = 20
        
        updateP1Label()
        updateP2Label()
        
        loserLabel.alpha = 0
    }
}

