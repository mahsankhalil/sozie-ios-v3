//
//  AddPostResponse.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 6/5/20.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit

struct AddPostResponse: Codable {
    var postId: Int
    var detail: String
    var taskInfo: TaskInfo
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case detail
        case taskInfo = "task_info"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        postId = try values.decode(Int.self, forKey: .postId)
        detail = try values.decode(String.self, forKey: .detail)
        taskInfo = try values.decode(TaskInfo.self, forKey: .taskInfo)
    }
}

struct Progress: Codable {
    var current: Float
    var total: Float
    var percent: Float
    enum CodingKeys: String, CodingKey {
        case current
        case total
        case percent
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        current = try values.decode(Float.self, forKey: .current)
        total = try values.decode(Float.self, forKey: .total)
        percent = try values.decode(Float.self, forKey: .percent)

    }
}

struct Info: Codable {
    var complete: Bool
    var success: Bool?
    var progress: Progress
    enum CodingKeys: String, CodingKey {
        case complete
        case success
        case progress
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        complete = try values.decode(Bool.self, forKey: .complete)
        success = try? values.decode(Bool.self, forKey: .success)
        progress = try values.decode(Progress.self, forKey: .progress)
    }
}
struct ProgressResponse: Codable {
    var taskInfo: TaskInfo
    enum CodingKeys: String, CodingKey {
        case taskInfo = "task_info"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        taskInfo = try values.decode(TaskInfo.self, forKey: .taskInfo)
    }
}
struct TaskInfo: Codable {
    var taskId: String
    var taskStatus: String
    var info: Info
    enum CodingKeys: String, CodingKey {
        case taskId = "task_id"
        case taskStatus = "task_status"
        case info
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        taskId = try values.decode(String.self, forKey: .taskId)
        taskStatus = try values.decode(String.self, forKey: .taskStatus)
        info = try values.decode(Info.self, forKey: .info)
    }
}
