//
//  MyUploadsCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 9/24/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
protocol MyUploadsCellDelegate: class {
    func editButtonTapped(button: UIButton)
    func warningButtonTapped(button: UIButton)
    func imageTapped(collectionViewTag: Int, cellTag: Int )
}

class MyUploadsCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: MyUploadsCellDelegate?
    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    @IBOutlet weak var warningButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    var viewModels: [UploadViewModel] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.register(UINib(nibName: "PostSizeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PostSizeCollectionViewCell")

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func editButtonTapped(_ sender: Any) {
        delegate?.editButtonTapped(button: sender as! UIButton)
    }
    @IBAction func warningButtonTapped(_ sender: Any) {
        delegate?.warningButtonTapped(button: sender as! UIButton)
    }
}
extension MyUploadsCell: ButtonProviding {
    func assignTagWith(_ index: Int) {
        warningButton.tag = index
        editButton.tag = index
        collectionView.tag = index
    }
}
extension MyUploadsCell: CellConfigurable {
    func setup(_ viewModel: RowViewModel) {
        if let postViewModel = viewModel as? UserPostWithUploadsViewModel {
            viewModels.removeAll()
            let productImageViewModel = UploadViewModel(imageURL: URL(string: postViewModel.productURL)!, status: "P", isApproved: false)
            viewModels.append(productImageViewModel)
            for upload in postViewModel.uploads {
                let currentViewModel = UploadViewModel(imageURL: URL(string: upload.imageURL)!, status: upload.reviewAction, isApproved: upload.isApproved)
                viewModels.append(currentViewModel)
            }
            if let videos = postViewModel.videos {
                for video in videos {
                    let videoViewModel = UploadViewModel(imageURL: URL(string: ""), status: video.reviewAction, isApproved: video.isApproved, isVideo: true, videoURL: video.videoURL)
                    viewModels.append(videoViewModel)
                }
            }
            switch postViewModel.postType {
            case .success:
                self.editButton.isHidden = true
                self.warningButton.isHidden = true
            case .inReview:
                self.editButton.isHidden = false
                self.warningButton.isHidden = true
            case .redo:
                self.editButton.isHidden = true
                self.warningButton.isHidden = false
            }
            self.collectionView.reloadData()
        }
    }
}
extension MyUploadsCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rowViewModel = viewModels[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostSizeCollectionViewCell", for: indexPath)
        if let cellConfigurable = cell as? CellConfigurable {
            cellConfigurable.setup(rowViewModel)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let availableWidth: Int = Int(UIScreen.main.bounds.size.width - 6 )
//        let widthPerItem = Double(availableWidth/3)
        return CGSize(width: 120, height: 120*16/9 )
    }
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3.0
    }
    // 4
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3.0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.imageTapped(collectionViewTag: collectionView.tag, cellTag: indexPath.row)
    }
}
