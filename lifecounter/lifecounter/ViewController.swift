import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loserLabel: UILabel!
    @IBOutlet weak var mainContainerStack: UIStackView!
    @IBOutlet weak var playerContainerStack: UIStackView!
    @IBOutlet weak var addPlayerButton: UIButton!
    @IBOutlet weak var resetGameButton: UIButton!
    
    var players: [UIView] = []
    var playerLives: [Int] = []
    var historyLog: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        resetGame(self)
    }


    @IBAction func showHistory(_ sender: UIButton) {
        let historyVC = HistoryViewController(nibName: "HistoryView", bundle: nil)
        historyVC.history = historyLog
        present(historyVC, animated: true, completion: nil)
    }

    func addPlayer(name: String) {
        let playerIndex = players.count
        playerLives.append(20)

        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.textAlignment = .center

        let lifeLabel = UILabel()
        lifeLabel.text = "20"
        lifeLabel.font = UIFont.systemFont(ofSize: 32)
        lifeLabel.textAlignment = .center

        let inputField = UITextField()
        inputField.text = "5"
        inputField.textAlignment = .center
        inputField.keyboardType = .numberPad
        inputField.borderStyle = .roundedRect
        inputField.widthAnchor.constraint(equalToConstant: 60).isActive = true

        func updateLifeLabel() {
            lifeLabel.text = "\(playerLives[playerIndex])"
        }

        func checkForLoser() {
            for (index, life) in playerLives.enumerated() {
                if life <= 0 {
                    loserLabel.text = "Player \(index + 1) loses!"
                    loserLabel.alpha = 1
                    return
                }
            }
            loserLabel.alpha = 0
        }

        let minusOne = UIButton(type: .system)
        minusOne.setTitle("-1", for: .normal)
        minusOne.addAction(UIAction { _ in
            self.playerLives[playerIndex] = max(self.playerLives[playerIndex] - 1, 0)
            updateLifeLabel()
            checkForLoser()
        }, for: .touchUpInside)

        let plusOne = UIButton(type: .system)
        plusOne.setTitle("+1", for: .normal)
        plusOne.addAction(UIAction { _ in
            self.playerLives[playerIndex] += 1
            updateLifeLabel()
            checkForLoser()
        }, for: .touchUpInside)

        let subtract = UIButton(type: .system)
        subtract.setTitle("-", for: .normal)
        subtract.addAction(UIAction { _ in
            if let delta = Int(inputField.text ?? "") {
                let actual = min(delta, self.playerLives[playerIndex])
                self.playerLives[playerIndex] -= actual
                updateLifeLabel()
                checkForLoser()
                self.historyLog.append("\(name) lost \(actual) life.")
                self.addPlayerButton.isEnabled = false
            }
        }, for: .touchUpInside)

        let add = UIButton(type: .system)
        add.setTitle("+", for: .normal)
        add.addAction(UIAction { _ in
            if let delta = Int(inputField.text ?? "") {
                self.playerLives[playerIndex] += delta
                updateLifeLabel()
                checkForLoser()
                self.historyLog.append("\(name) gained \(delta) life.")
                self.addPlayerButton.isEnabled = false
            }
        }, for: .touchUpInside)

        let topStack = UIStackView(arrangedSubviews: [minusOne, lifeLabel, plusOne])
        topStack.axis = .horizontal
        topStack.distribution = .fillEqually
        topStack.alignment = .center

        let bottomStack = UIStackView(arrangedSubviews: [subtract, inputField, add])
        bottomStack.axis = .horizontal
        bottomStack.distribution = .fillEqually
        bottomStack.alignment = .center

        let fullStack = UIStackView(arrangedSubviews: [nameLabel, topStack, bottomStack])
        fullStack.axis = .vertical
        fullStack.spacing = 10
        fullStack.translatesAutoresizingMaskIntoConstraints = false
        fullStack.layer.borderWidth = 1
        fullStack.layer.cornerRadius = 8
        fullStack.layer.borderColor = UIColor.lightGray.cgColor
        fullStack.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        fullStack.isLayoutMarginsRelativeArrangement = true
        fullStack.setContentHuggingPriority(.required, for: .vertical)
        fullStack.setContentCompressionResistancePriority(.required, for: .vertical)

        players.append(fullStack)
        playerContainerStack.addArrangedSubview(fullStack)
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
        playerLives.removeAll()

        for i in 1...4 {
            addPlayer(name: "Player \(i)")
        }

        loserLabel.alpha = 0
        addPlayerButton.isEnabled = true
    }
}
