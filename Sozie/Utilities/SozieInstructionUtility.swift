//
//  SozieInstructionUtility.swift
//  Sozie
//
//  Created by Ahsan Khalil on 04/12/2020.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import Foundation

struct SozieInstructionUtility {
    private static func getSozieTommyMaleInstructions() -> [[String]] {
        var set = [[String]]()
        //instruction heading and cross btn header title
        set.append([])
        //Instructions
        var instructionList = [String]()
        instructionList.append("Accept Requests")
        instructionList.append("Receive Iems")
        instructionList.append("Create Content")
        instructionList.append("Submit!")
        set.append(instructionList)
        //Image Pose
        set.append([])
        //Do list
        var doList = [String]()
        doList.append("Have well groomed hair.")
        doList.append("Wear shoes 👟 that complement the look.")
        doList.append("Style poses")
        doList.append("Take bright 💡 pictures.")
        doList.append("Follow the content guidelines for pictures and videos.")
        doList.append("Smile :)")
        //Donot list
        var donotList = [String]()
        donotList.append("Have underware lines.")
        donotList.append("Wear dirty clothes.")
        donotList.append("Have a messy background.")
        set.append(doList)
        set.append(donotList)
        //close button list
        set.append([])
        return set
    }
    private static func getSozieTommyFemaleInstructions() -> [[String]] {
        var set = [[String]]()
        //instruction heading and cross btn header title
        set.append([])
        //Instructions
        var instructionList = [String]()
        instructionList.append("Accept Requests")
        instructionList.append("Receive Iems")
        instructionList.append("Create Content")
        instructionList.append("Submit!")
        set.append(instructionList)
        //Image Pose
        set.append([])
        //Do list
        var doList = [String]()
        doList.append("Have well groomed hair and clean nails. 💅🏻")
        doList.append("Make up. 💄")
        doList.append("Wear shoes 👠 that complement the look.")
        doList.append("Style poses")
        doList.append("Take bright 💡 pictures.")
        doList.append("Follow the content guidelines for pictures and videos.")
        doList.append("Smile :)")
        //Donot list
        var donotList = [String]()
        donotList.append("Have underware lines.")
        donotList.append("Wear dirty clothes.")
        donotList.append("Have a messy background.")
        set.append(doList)
        set.append(donotList)
        //close button list
        set.append([])
        return set
    }
    private static func getSozieTargetFemaleInstructions() -> [[String]] {
        var set = [[String]]()
        //instruction heading and cross btn header title
        set.append([])
        //Instructions
        var instructionList = [String]()
        instructionList.append("Accept request for clothes in your size")
        instructionList.append("Have your full length picture taken. Below are three requested angles (front, back, side")
        instructionList.append("Hide Tags")
        instructionList.append("Fill in the Sozie Fit Tips")
        instructionList.append("Submit!")
        set.append(instructionList)
        //Image Pose
        set.append(["female_target_pose_picture"])
        //Do list
        var doList = [String]()
        doList.append("Have well groomed hair and clean nails. 💅🏻")
        doList.append("Make up. 💄")
        doList.append("Wear shoes 👠 that complement the look.")
        doList.append("Style poses")
        doList.append("Take bright 💡 pictures.")
        doList.append("Make sure angles & poses match the above.")
        doList.append("Smile :)")
        //Donot list
        var donotList = [String]()
        donotList.append("Have underware lines.")
        donotList.append("Wear dirty clothes.")
        donotList.append("Have people or a mess in the background.")
        donotList.append("Leave a mess.")
        set.append(doList)
        set.append(donotList)
        //close button list
        set.append([])
        return set
    }
    private static func getSozieAddidasFemaleInstructions() -> [[String]] {
        var set = [[String]]()
        //instruction heading and cross btn header title
        set.append([])
        //Instructions
        var instructionList = [String]()
        instructionList.append("Accept request for clothes in your size")
        instructionList.append("Have your full length picture taken. Below are three requested angles (front, back, side")
        instructionList.append("Hide Tags")
        instructionList.append("Fill in the Sozie Fit Tips")
        instructionList.append("Submit!")
        set.append(instructionList)
        //Image Pose
        set.append(["instructionsFemalePosture"])
        //Do list
        var doList = [String]()
        doList.append("Have well groomed hair and clean nails. 💅🏻")
        doList.append("Make up. 💄")
        doList.append("Wear shoes 👠 that complement the look.")
        doList.append("Style poses")
        doList.append("Take bright 💡 pictures.")
        doList.append("Make sure angles & poses match the above.")
        doList.append("Smile :)")
        //Donot list
        var donotList = [String]()
        donotList.append("Have underware lines.")
        donotList.append("Wear dirty clothes.")
        donotList.append("Have people or a mess in the background.")
        donotList.append("Leave a mess.")
        set.append(doList)
        set.append(donotList)
        //close button list
        set.append([])
        return set
    }
    private static func getSozieMenInstructions() -> [[String]] {
        var set = [[String]]()
        //instruction heading and cross btn header title
        set.append([])
        //Instructions
        var instructionList = [String]()
        instructionList.append("Accept request for clothes in your size")
        instructionList.append("Have your full length picture taken. Below are three requested angles (front, back, side Have your full length picture taken. Below are three requested angles (front, back, side Have your full length picture taken. Below are three requested angles (front, back, side Have your full length picture taken. Below are three requested angles (front, back, side Have your full length picture taken. Below are three requested angles (front, back, side Have your full length picture taken. Below are three requested angles (front, back, side")
        instructionList.append("Hide Tags")
        instructionList.append("Fill in the Sozie Fit Tips")
        instructionList.append("Submit!")
        set.append(instructionList)
        //Image Pose
        set.append(["instructionsMalePosture"])
        //Do list
        var doList = [String]()
        doList.append("Have well groomed hair.")
        doList.append("Wear shoes 👟 that complement the look.")
        doList.append("Style poses")
        doList.append("Take bright 💡 pictures.")
        doList.append("Make sure angles & poses match the above.")
        doList.append("Smile :)")
        //Donot list
        var donotList = [String]()
        donotList.append("Have underware lines.")
        donotList.append("Wear dirty clothes.")
        donotList.append("Have people or a mess in the background.")
        donotList.append("Leave a mess.")
        set.append(doList)
        set.append(donotList)
        //close button list
        set.append([])
        return set
    }
    static func getSozieCompleteInstructionsSet() -> [[String]] {
        let instructionSet: [[String]] = [[String]]()
        if let gender = UserDefaultManager.getCurrentUserGender() {
            if gender == "M" {
                if UserDefaultManager.getALlBrands()?.count ?? 0 > 0 {
                    let brands = UserDefaultManager.getALlBrands()
                    if brands?[0].label == "Tommy" {
                       return getSozieTommyMaleInstructions()
                    }
                    return getSozieMenInstructions()
                }
            } else {
                if UserDefaultManager.getALlBrands()?.count ?? 0 > 0 {
                    let brands = UserDefaultManager.getALlBrands()
                    if brands?[0].label == "Adidas" {
                        return getSozieAddidasFemaleInstructions()
                    } else if brands?[0].label == "Target"{
                        return getSozieTargetFemaleInstructions()
                    } else if brands?[0].label == "Tommy"{
                        return getSozieTommyFemaleInstructions()
                    }
                } else {
                    return getSozieAddidasFemaleInstructions()
                }
            }
        }
        return instructionSet
    }
    static func getSozieInstructionsSetTitleList() -> [String] {
        var instructionSet: [String] =
            [
                "Instruction Title",
                "SOZIE INSTRUCTIONS",
                "Image Title",
                "DO",
                "DO NOT",
                "Close Button"
            ]
        if UserDefaultManager.getALlBrands()?.count ?? 0 > 0 {
            let brands = UserDefaultManager.getALlBrands()
            if brands?[0].label == "Tommy" {
                instructionSet[0] = "HOW TO USE SOZIE"
            }
        }
        return instructionSet
    }
}
