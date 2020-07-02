//
//  PosePopupVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 5/28/20.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit

class PosePopupVC: UIViewController {

    @IBOutlet weak var bottomLabel: UILabel!
    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    @IBOutlet weak var nextButton: DZGradientButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModels: [ImageViewModel] = []
    var photoIndex: Int? = 0
    var closeHandler: (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.register(UINib(nibName: "ImageViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageViewCell")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let index = photoIndex {
            switch index {
            case 0:
                self.populateFrontPoseImages()
                self.bottomLabel.text = "Front poses that work"
            case 1:
                self.populateBackPoseImages()
                self.bottomLabel.text = "Back poses that work"
            case 2:
                self.populateSidePoseImages()
                self.bottomLabel.text = "Side poses that work"
            default:
                self.populateFrontPoseImages()
                self.bottomLabel.text = "Front poses that work"
            }
        } else {
            self.populateFrontPoseImages()
            self.bottomLabel.text = "Front poses that work"
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if let index = photoIndex {
//            switch index {
//            case 0:
//                self.populateFrontPoseImages()
//            case 1:
//                self.populateBackPoseImages()
//            case 2:
//                self.populateSidePoseImages()
//            default:
//                return
//            }
//        }
    }
    static func instance(photoIndex: Int?) -> PosePopupVC {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let instnce = storyboard.instantiateViewController(withIdentifier: "PosePopupVC") as! PosePopupVC
        instnce.view.layer.cornerRadius = 10.0
        instnce.view.clipsToBounds = true
        instnce.photoIndex = photoIndex
        return instnce
    }
    func populateFrontPoseImages() {
        for index in 0..<9 {
            let name = "Front-" + String(index + 1)
            let viewModel = ImageViewModel(imageName: name)
            viewModels.append(viewModel)
        }
        self.collectionView.reloadData()
    }

    func populateBackPoseImages() {
        for index in 0..<9 {
            let name = "Back-" + String(index + 1)
            let viewModel = ImageViewModel(imageName: name)
            viewModels.append(viewModel)
        }
        self.collectionView.reloadData()
    }
    func populateSidePoseImages() {
        for index in 0..<9 {
            let name = "Side-" + String(index + 1)
            let viewModel = ImageViewModel(imageName: name)
            viewModels.append(viewModel)
        }
        self.collectionView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func nextButtonTapped(_ sender: Any) {
        self.closeHandler!()
    }

}
extension PosePopupVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rowViewModel = viewModels[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageViewCell", for: indexPath)
        if let cellConfigurable = cell as? CellConfigurable {
            cellConfigurable.setup(rowViewModel)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth: Int = Int(UIScreen.main.bounds.size.width - 20)
        let widthPerItem = Double(availableWidth/3)
        let heightPerItem = Double(widthPerItem * 1.9126)
        return CGSize(width: widthPerItem, height: heightPerItem )
    }
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: (UIScreen.main.bounds.size.width - 20.0 - (104 * 3))/4, bottom: 0, right: (UIScreen.main.bounds.size.width - 20.0 - (104 * 3))/4)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return (UIScreen.main.bounds.size.width - 20.0 - (103 * 3))/4
    }
    // 4
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
extension PosePopupVC: PopupContentViewController {
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        var topSafeArea: CGFloat = 0.0
        var bottomSafeArea: CGFloat = 0.0
        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.keyWindow {
                bottomSafeArea = window.safeAreaInsets.bottom
                topSafeArea = window.safeAreaInsets.top
            }
        }
        return CGSize(width: UIScreen.main.bounds.size.width - 20.0, height: UIScreen.main.bounds.size.height - 20.0 - topSafeArea - bottomSafeArea)
    }
}
