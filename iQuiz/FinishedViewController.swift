//
//  FinishedViewController.swift
//  iQuiz
//
//  Created by Kylie Uffie on 2/19/26.
//

import UIKit

class FinishedViewController: UIViewController {

    @IBOutlet weak var performanceLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!

    var score: Int = 0
    var total: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        scoreLabel.text = "\(score) of \(total) correct"

        if score == total {
            performanceLabel.text = "Perfect!"
        } else if score >= total - 1 {
            performanceLabel.text = "Almost!"
        } else {
            performanceLabel.text = "Better luck next time!"
        }
    }

    @IBAction func nextTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
}
