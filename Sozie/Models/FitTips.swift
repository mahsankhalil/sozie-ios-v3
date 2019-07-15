//
//  FitTips.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 7/3/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class FitTips: Codable {
    var label: String
    var question: [Question]
    enum CodingKeys: String, CodingKey {
        case label
        case question
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        label = try values.decode(String.self, forKey: .label)
        question = try values.decode([Question].self, forKey: .question)

    }
}

class Question: Codable {
    var questionId: Int
    var questionText: String
    var type: String
    var options: [Options]
    var isAnswered = false
    var answer: String?
    enum CodingKeys: String, CodingKey {
        case questionId = "id"
        case questionText = "question_text"
        case type
        case options
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        questionId = try values.decode(Int.self, forKey: .questionId)
        questionText = try values.decode(String.self, forKey: .questionText)
        type = try values.decode(String.self, forKey: .type)
        options = try values.decode([Options].self, forKey: .options)
    }
}

class Options: Codable {
    var optionText: String
    enum CodingKeys: String, CodingKey {
        case optionText = "option_text"
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        optionText = try values.decode(String.self, forKey: .optionText)

    }
}
