//
//  ViewController.swift
//  iQuiz
//
//  Created by Kylie Uffie on 2/17/26.
//

import UIKit

class ViewController: UITableViewController {

    let quizzes: [Quiz] = [
        Quiz(title: "Mathematics", desc: "Test you math skills", iconName: "function"),
        Quiz(title: "Marvel Super Heroes", desc: "How well do you know Marvel?", iconName: "bolt.fill"),
        Quiz(title: "Science", desc: "Physics, bio, and random facts", iconName: "atom")]
        
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

