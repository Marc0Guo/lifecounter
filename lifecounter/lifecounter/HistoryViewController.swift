//
//  HistoryViewController.swift
//  lifecounter
//
//  Created by 郭家玮 on 4/23/25.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    var history: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = history.joined(separator: "\n")
    }

    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
