//
//  QuizDataManager.swift
//  iQuiz
//
//  Created by Kylie Uffie on 2/25/26.
//

import Foundation

final class QuizDataManager {
    static let shared = QuizDataManager()
    private init() {}

    private let defaultURLString = "http://tednewardsandbox.site44.com/questions.json"
    private let urlKey = "quizURL"

    // this is what the app uses as its current quiz data
    var quizzes: [Quiz] = []

    // persisted setting
    var currentURLString: String {
        get { UserDefaults.standard.string(forKey: urlKey) ?? defaultURLString }
        set { UserDefaults.standard.set(newValue, forKey: urlKey) }
    }

    func fetchQuizzes(completion: @escaping (Result<[Quiz], Error>) -> Void) {
        guard let url = URL(string: currentURLString) else {
            completion(.failure(NSError(domain: "BadURL", code: 0)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0)))
                return
            }

            do {
                let dto = try JSONDecoder().decode([QuizDTO].self, from: data)

                let mapped: [Quiz] = dto.map { qz in
                    let questions: [Question] = qz.questions.map { q in
                        let correctIndex = q.answers.firstIndex(of: q.answer) ?? 0
                        return Question(text: q.text, answers: q.answers, correctIndex: correctIndex)
                    }

                    // icon not in JSON, so pick something default
                    return Quiz(title: qz.title, desc: qz.desc, iconName: "questionmark.circle", questions: questions)
                }

                completion(.success(mapped))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
