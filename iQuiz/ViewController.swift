//
//  ViewController.swift
//  iQuiz
//
//  Created by Kylie Uffie on 2/17/26.
//

import UIKit

class ViewController: UITableViewController {

    let quizzes: [Quiz] = [
      Quiz(title: "Mathematics", desc: "Test your math skills", iconName: "function", questions: [
        Question(text: "2 + 2 = ?", answers: ["3","4","5"], correctIndex: 1),
        Question(text: "5 * 3 = ?", answers: ["15","10","8"], correctIndex: 0),
        Question(text: "12 ÷ 4 = ?", answers: ["2", "3", "4"], correctIndex: 1),
        Question(text: "9 - 6 = ?", answers: ["1", "2", "3"], correctIndex: 2),
        Question(text: "Square root of 16?", answers: ["2", "4", "8"], correctIndex: 1)
      ]),
      Quiz(title: "Marvel Super Heroes", desc: "How well do you know Marvel?", iconName: "shield.fill", questions: [
        Question(text: "Who is Iron Man?", answers: ["Tony Stark","Steve Rogers","Bruce Banner"], correctIndex: 0),
        Question(text: "Who is Captain America?", answers: ["Clint Barton", "Steve Rogers", "Thor"], correctIndex: 1),
        Question(text: "What is Thor’s weapon called?", answers: ["Stormbreaker", "Mjolnir", "Vibranium"], correctIndex: 1),
        Question(text: "What metal is Captain America’s shield made of?", answers: ["Adamantium", "Vibranium", "Titanium"], correctIndex: 1),
        Question(text: "Who turns into the Hulk?", answers: ["Bruce Banner", "Peter Parker", "Scott Lang"], correctIndex: 0)
      ]),
      Quiz(title: "Science", desc: "Physics, bio, and random facts", iconName: "atom", questions: [
        Question(text: "Water’s chemical formula?", answers: ["CO2","H2O","O2"], correctIndex: 1),
        Question(text: "Earth revolves around the ____.", answers: ["Moon", "Sun", "Mars"], correctIndex: 1),
        Question(text: "Gas we breathe in to survive?", answers: ["Carbon Dioxide", "Oxygen", "Nitrogen"], correctIndex: 1),
        Question(text: "State of matter with fixed shape?", answers: ["Liquid", "Gas", "Solid"], correctIndex: 2),
        Question(text: "Boiling point of water (°C)?", answers: ["50", "100", "150"], correctIndex: 1)
      ])
    ]
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "toQuestion", sender: indexPath)
        }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQuestion",
        let indexPath = sender as? IndexPath,
        let vc = segue.destination as? QuestionViewController {
            vc.quiz = quizzes[indexPath.row]
            vc.questionIndex = 0
            vc.score = 0
            }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "iQuiz"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Settings",
            style: .plain,
            target: self,
            action: #selector(settingsTapped)
        )
    }
    
    @objc func settingsTapped() {
        let alert = UIAlertController(
            title: nil,
            message: "Settings go here",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return quizzes.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCell")
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: "QuizCell")
        
        let quiz = quizzes[indexPath.row]
        cell.textLabel?.text = quiz.title
        cell.detailTextLabel?.text = quiz.desc
        cell.imageView?.image = UIImage(systemName: quiz.iconName)
        
        return cell
    }
}

