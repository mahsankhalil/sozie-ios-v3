//
//  Double.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/15/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

extension Double {
    func feetToFeetInches() -> String {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.unitStyle = .short
        let rounded = self.rounded(.towardZero)
        let feet = NSMeasurement(doubleValue: rounded, unit: UnitLength.feet)
        let inches = NSMeasurement(doubleValue: self - rounded, unit: UnitLength.feet).converting(to: UnitLength.inches)
        return ("\(formatter.string(from: feet as Measurement)) \(formatter.string(from: inches as Measurement))")
    }
    func inchesToFeet() -> String {
        let feet = Int(self)/12
        return String(feet)
    }
    func inchesToRemainingInches() -> String {
        let feet = Int(self)%12
        return String(feet)
    }
}
