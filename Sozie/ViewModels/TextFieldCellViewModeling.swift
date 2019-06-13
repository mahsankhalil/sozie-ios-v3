//
//  TextFieldCellViewModeling.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 6/12/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

protocol TextFieldCellViewModeling {
    var title: String { get }
    var text: String? { get }
    var values: [String] { get }
    var textFieldDelegate: TextFieldDelegate { get }
}
