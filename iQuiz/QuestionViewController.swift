//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Kylie Uffie on 2/19/26.
//


import UIKit

class QuestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answersTableView: UITableView!

    var quiz: Quiz!
    var questionIndex: Int = 0
    var score: Int = 0

    private var selectedAnswerIndex: Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        title = quiz.title

        answersTableView.dataSource = self
        answersTableView.delegate = self

        answersTableView.allowsMultipleSelection = false

        loadQuestion()
    }

    private func loadQuestion() {
        let q = quiz.questions[questionIndex]
        questionLabel.text = q.text
        selectedAnswerIndex = nil
        answersTableView.reloadData()
    }

    // MARK: - TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quiz.questions[questionIndex].answers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell")
            ?? UITableViewCell(style: .default, reuseIdentifier: "AnswerCell")

        let answer = quiz.questions[questionIndex].answers[indexPath.row]
        cell.textLabel?.text = answer
        cell.accessoryType = (indexPath.row == selectedAnswerIndex) ? .checkmark : .none

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAnswerIndex = indexPath.row
        tableView.reloadData()
    }

    // MARK: - Submit

    @IBAction func submitTapped(_ sender: UIButton) {
        guard selectedAnswerIndex != nil else {
            let alert = UIAlertController(title: "Pick an answer", message: "Select one option before submitting.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        performSegue(withIdentifier: "toAnswer", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAnswer",
           let vc = segue.destination as? AnswerViewController {

            vc.quiz = quiz
            vc.questionIndex = questionIndex
            vc.score = score
            vc.selectedAnswerIndex = selectedAnswerIndex!
        }
    }
}