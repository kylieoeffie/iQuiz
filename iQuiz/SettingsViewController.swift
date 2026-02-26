//
//  SettingsViewController.swift
//  iQuiz
//
//  Created by Kylie Uffie on 2/25/26.
//


import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var urlTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        urlTextField.text = QuizDataManager.shared.currentURLString
    }

    @IBAction func checkNowTapped(_ sender: UIButton) {
        let text = urlTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !text.isEmpty {
            QuizDataManager.shared.currentURLString = text
        }

        QuizDataManager.shared.fetchQuizzes { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let newQuizzes):
                    QuizDataManager.shared.quizzes = newQuizzes
                    self.showOK("Updated!", "Downloaded latest quizzes.")
                case .failure:
                    self.showOK("Network Error", "Couldn’t download quizzes. Check connection or URL.")
                }
            }
        }
    }

    private func showOK(_ title: String, _ msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}