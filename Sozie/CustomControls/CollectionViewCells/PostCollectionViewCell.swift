//
//  PostCollectionViewCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/13/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var waistLabel: UILabel!
    @IBOutlet weak var hipLabel: UILabel!
    @IBOutlet weak var braLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var sizeWornView: UIView!
    @IBOutlet weak var sizeWornLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.makeViewCircle()
        profileImageView.applyStandardBorder(hexColor: "A6A6A6")
    }
    @IBAction func followButtonTapped(_ sender: Any) {
    }
    @IBAction func moreButtonTapped(_ sender: Any) {
    }
    
}
extension PostCollectionViewCell: CellConfigurable {
    func setup(_ viewModel: RowViewModel) {

    }
    
}
