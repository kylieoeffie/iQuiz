//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Kylie Uffie on 2/19/26.
//

import UIKit

class AnswerViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var correctAnswerLabel: UILabel!

    var quiz: Quiz!
    var questionIndex: Int = 0
    var score: Int = 0
    var selectedAnswerIndex: Int = 0

    private var isCorrect: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        title = quiz.title

        let q = quiz.questions[questionIndex]
        questionLabel.text = q.text

        isCorrect = (selectedAnswerIndex == q.correctIndex)

        if isCorrect {
            resultLabel.text = "✅ Correct!"
            score += 1
        } else {
            resultLabel.text = "❌ Wrong"
        }

        let correctAnswerText = q.answers[q.correctIndex]
        correctAnswerLabel.text = "Correct Answer: \(correctAnswerText)"

        // Optional: swipe gestures for extra credit (right = next, left = quit)
        addSwipeGestures()
    }

    @IBAction func nextTapped(_ sender: UIButton) {
        let nextIndex = questionIndex + 1

        if nextIndex < quiz.questions.count {
            performSegue(withIdentifier: "toNextQuestion", sender: nextIndex)
        } else {
            performSegue(withIdentifier: "toFinished", sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "toNextQuestion",
           let nextIndex = sender as? Int,
           let vc = segue.destination as? QuestionViewController {

            vc.quiz = quiz
            vc.questionIndex = nextIndex
            vc.score = score
        }

        if segue.identifier == "toFinished",
           let vc = segue.destination as? FinishedViewController {

            vc.score = score
            vc.total = quiz.questions.count
        }
    }

    // MARK: - Swipe Gestures (Extra Credit)

    private func addSwipeGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }

    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            nextTapped(UIButton())
        } else if gesture.direction == .left {
            // abandon quiz, throw away progress, return to list
            navigationController?.popToRootViewController(animated: true)
        }
    }
}
