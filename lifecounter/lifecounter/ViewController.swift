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
    var playerNames: [String] = []

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
        nameLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleNameTap(_:)))
        nameLabel.addGestureRecognizer(tapGesture)
        playerNames.append(name)

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
            let alivePlayers = playerLives.filter { $0 > 0 }.count

            for (index, life) in playerLives.enumerated() {
                if life <= 0 {
                    loserLabel.text = "Player \(index + 1) loses!"
                    loserLabel.alpha = 1

                    if index < self.players.count {
                        let playerView = self.players[index]
                        for subview in playerView.subviews {
                            if let stack = subview as? UIStackView {
                                for item in stack.arrangedSubviews {
                                    if let button = item as? UIButton {
                                        button.isEnabled = false
                                    }
                                }
                            }
                        }
                    }
                }
            }

            if alivePlayers == 1 {
                let alert = UIAlertController(title: "Game over!", message: nil, preferredStyle: .alert)
                self.historyLog.append("Game over!")
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.resetGame(self)
                }))
                present(alert, animated: true, completion: nil)
            }
        }
        
        func configureStyledButton(title: String, backgroundColor: UIColor, tintColor: UIColor) -> UIButton {
            var config = UIButton.Configuration.filled()
            config.title = title
            config.baseBackgroundColor = backgroundColor
            config.baseForegroundColor = tintColor
            config.cornerStyle = .medium
            config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
            let button = UIButton(configuration: config)
            return button
        }

        let minusOne = configureStyledButton(
            title: "-1",
            backgroundColor: UIColor.systemRed.withAlphaComponent(0.2),
            tintColor: .systemRed
        )
        minusOne.addAction(UIAction { _ in
            self.playerLives[playerIndex] = max(self.playerLives[playerIndex] - 1, 0)
            let currentName = self.playerNames[playerIndex]
            self.historyLog.append("\(currentName) lost 1 life.")
            updateLifeLabel()
            checkForLoser()
            self.addPlayerButton.isEnabled = false
        }, for: .touchUpInside)

        let plusOne = configureStyledButton(
            title: "+1",
            backgroundColor: UIColor.systemTeal.withAlphaComponent(0.2),
            tintColor: .systemTeal
        )
        plusOne.addAction(UIAction { _ in
            self.playerLives[playerIndex] += 1
            updateLifeLabel()
            checkForLoser()
            let currentName = self.playerNames[playerIndex]
            self.historyLog.append("\(currentName) gain 1 life.")
            self.addPlayerButton.isEnabled = false
        }, for: .touchUpInside)

        let subtract = configureStyledButton(
            title: "-",
            backgroundColor: UIColor.systemRed.withAlphaComponent(0.2),
            tintColor: .systemRed
        )
        subtract.addAction(UIAction { _ in
            if let delta = Int(inputField.text ?? "") {
                let actual = min(delta, self.playerLives[playerIndex])
                self.playerLives[playerIndex] -= actual
                let currentName = self.playerNames[playerIndex]
                self.historyLog.append("\(currentName) lost \(actual) life.")
                updateLifeLabel()
                checkForLoser()
                self.addPlayerButton.isEnabled = false
            }
        }, for: .touchUpInside)

        let add = configureStyledButton(
            title: "+",
            backgroundColor: UIColor.systemTeal.withAlphaComponent(0.2),
            tintColor: .systemTeal
        )
        add.addAction(UIAction { _ in
            if let delta = Int(inputField.text ?? "") {
                self.playerLives[playerIndex] += delta
                updateLifeLabel()
                checkForLoser()
                let currentName = self.playerNames[playerIndex]
                self.historyLog.append("\(currentName) gained \(delta) life.")
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
        self.historyLog.append("Player \(nextPlayerIndex) added")
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
    
    @objc func handleNameTap(_ sender: UITapGestureRecognizer) {
        guard let tappedLabel = sender.view as? UILabel else { return }

        for (index, playerView) in players.enumerated() {
            if let stack = playerView as? UIStackView,
               let label = (stack.arrangedSubviews.first as? UILabel),
               label == tappedLabel {

                let alert = UIAlertController(title: "Edit Name", message: "Enter a new name", preferredStyle: .alert)
                alert.addTextField { textField in
                    textField.placeholder = "Player \(index + 1)"
                    textField.text = self.playerNames[index]
                }
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    if let newName = alert.textFields?.first?.text, !newName.isEmpty {
                        label.text = newName
                        self.playerNames[index] = newName
                    }
                }))
                present(alert, animated: true, completion: nil)
                break
            }
        }
    }

}
