//
//  PostFitTips.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 6/8/20.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit

struct PostFitTips: Codable {
    var questionId: Int
    var type: String
    var answerText: String
    enum CodingKeys: String, CodingKey {
        case questionId = "question_id"
        case type
        case answerText = "answer_text"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        questionId = try values.decode(Int.self, forKey: .questionId)
        type = try values.decode(String.self, forKey: .type)
        answerText = try values.decode(String.self, forKey: .answerText)
    }
}
