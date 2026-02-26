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

    var quizzes: [Quiz] = []

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
                // ✅ fallback to cache
                if let cached = self.loadQuizzesFromCache() {
                    completion(.success(cached))
                } else {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                if let cached = self.loadQuizzesFromCache() {
                    completion(.success(cached))
                } else {
                    completion(.failure(NSError(domain: "NoData", code: 0)))
                }
                return
            }

            do {
                let dto = try JSONDecoder().decode([QuizDTO].self, from: data)

                self.saveQuizzesToCache(dto)

                let mapped: [Quiz] = dto.map { qz in
                    let questions: [Question] = qz.questions.map { q in
                        let correctIndex = q.answers.firstIndex(of: q.answer) ?? 0
                        return Question(text: q.text, answers: q.answers, correctIndex: correctIndex)
                    }
                    return Quiz(title: qz.title, desc: qz.desc, iconName: "questionmark.circle", questions: questions)
                }

                completion(.success(mapped))
            } catch {
                if let cached = self.loadQuizzesFromCache() {
                    completion(.success(cached))
                } else {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    private var cacheURL: URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docs.appendingPathComponent("quizzes_cache.json")
    }

    func saveQuizzesToCache(_ quizzes: [QuizDTO]) {
        do {
            let data = try JSONEncoder().encode(quizzes)
            try data.write(to: cacheURL, options: .atomic)
            print("✅ Saved cache to \(cacheURL)")
        } catch {
            print("❌ Failed to save cache:", error)
        }
    }

    func loadQuizzesFromCache() -> [Quiz]? {
        do {
            let data = try Data(contentsOf: cacheURL)
            let dto = try JSONDecoder().decode([QuizDTO].self, from: data)

            let mapped: [Quiz] = dto.map { qz in
                let questions: [Question] = qz.questions.map { q in
                    let correctIndex = q.answers.firstIndex(of: q.answer) ?? 0
                    return Question(text: q.text, answers: q.answers, correctIndex: correctIndex)
                }
                return Quiz(title: qz.title, desc: qz.desc, iconName: "questionmark.circle", questions: questions)
            }
            print("✅ Loaded cache")
            return mapped
        } catch {
            print("❌ Failed to load cache:", error)
            return nil
        }
    }
}
