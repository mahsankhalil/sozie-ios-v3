//
//  SozieInstructionUtility.swift
//  Sozie
//
//  Created by Ahsan Khalil on 04/12/2020.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import Foundation

struct SozieInstructionUtility {
    static func getSozieUserInstructions(gender: String) -> [String] {
        var str = [String]()
        if gender == "M" {
            str.append("Accept request for clothes in your size")
            str.append("Have your full length picture taken. Below are three requested angles (front, back, side")
            str.append("Hide Tags")
            str.append("Fill in the Sozie Fit Tips")
            str.append("Submit!")
        } else {
            str.append("Accept request for clothes in your size")
            str.append("Have your full length picture taken. Below are three requested angles (front, back, side")
            str.append("Hide Tags")
            str.append("Fill in the Sozie Fit Tips")
            str.append("Submit!")
        }
        return str
    }
    static func getSozieUserDoList(gender: String) -> [String] {
        var str = [String]()
        if gender == "M" {
            str.append("Have well groomed hair.")
            str.append("Wear shoes 👟 that complement the look.")
            str.append("Style poses")
            str.append("Take bright 💡 pictures.")
            str.append("Make sure angles & poses match the above.")
            str.append("Smile :)")
        } else {
            str.append("Have well groomed hair and clean nails. 💅🏻")
            str.append("Make up. 💄")
            str.append("Wear shoes 👠 that complement the look.")
            str.append("Style poses")
            str.append("Take bright 💡 pictures.")
            str.append("Make sure angles & poses match the above.")
            str.append("Smile :)")
        }
        return str
    }
    static func getSozieUserDonotList(gender: String) -> [String] {
        var str = [String]()
        if gender == "M" {
            str.append("Have underware lines.")
            str.append("Wear dirty clothes.")
            str.append("Have people or a mess in the background.")
            str.append("Leave a mess.")
        } else {
            str.append("Have underware lines.")
            str.append("Wear dirty clothes.")
            str.append("Have people or a mess in the background.")
            str.append("Leave a mess.")
        }
        return str
    }
}
