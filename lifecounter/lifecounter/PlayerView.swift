//
//  PlayerView.swift
//  lifecounter
//
//  Created by 郭家玮 on 4/22/25.
//

import UIKit

class PlayerView: UIView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lifeLabel: UILabel!
    @IBOutlet weak var inputField: UITextField!
    
    var checkForLoss: (() -> Void)?
    var notifyLifeChanged: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lifeLabel.text = "\(life)"
        inputField.text = "5"
        inputField.textAlignment = .center
    }
    
    var onLifeChangedWithText: ((String) -> Void)?
    
    var life: Int = 20 {
        didSet {
            lifeLabel.text = "\(life)"
            checkForLoss?()
            notifyLifeChanged?()
        }
    }
    
    @IBAction func addLife(_ sender: Any) {
        if let delta = Int(inputField.text ?? "") {
            life += delta
            onLifeChangedWithText?("\(nameLabel.text ?? "Player") gained \(delta) life.")
        }
    }

    @IBAction func subtractLife(_ sender: Any) {
        if let delta = Int(inputField.text ?? "") {
            let actualDelta = min(delta, life)
            life -= actualDelta
            onLifeChangedWithText?("\(nameLabel.text ?? "Player") lost \(actualDelta) life.")
        }
    }
    
    @IBAction func addOne(_ sender: Any) {
        life += 1
    }

    @IBAction func subtractOne(_ sender: Any) {
        life = max(life - 1, 0)
    }
}
