//
//  Quiz.swift
//  iQuiz
//
//  Created by Kylie Uffie on 2/17/26.
//

import UIKit

struct Question {
    let text: String
    let answers: [String]
    let correctIndex: Int
}

struct Quiz {
    let title: String
    let desc: String
    let iconName: String
    let questions: [Question]
}

import Foundation

struct QuizDTO: Decodable {
    let title: String
    let desc: String
    let questions: [QuestionDTO]
}

struct QuestionDTO: Decodable {
    let text: String
    let answer: String
    let answers: [String]
}
