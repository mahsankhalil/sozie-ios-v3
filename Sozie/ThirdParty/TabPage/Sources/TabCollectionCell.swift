//
//  TabCollectionCell.swift
//  TabPageViewController
//
//  Created by EndouMari on 2016/02/24.
//  Copyright © 2016年 EndouMari. All rights reserved.
//

import UIKit
import EasyTipView
class TabCollectionCell: UICollectionViewCell {

    var tabItemButtonPressedBlock: (() -> Void)?
    var tipView: EasyTipView?
    var isFirstTime = true
    var option: TabPageOption = TabPageOption() {
        didSet {
            currentBarViewHeightConstraint.constant = option.currentBarHeight
        }
    }
    var item: String = "" {
        didSet {
            itemLabel.text = item
            itemLabel.invalidateIntrinsicContentSize()
            invalidateIntrinsicContentSize()
        }
    }
    var isCurrent: Bool = false {
        didSet {
            currentBarView.isHidden = !isCurrent
            if isCurrent {
                highlightTitle()
            } else {
                unHighlightTitle()
            }
            currentBarView.backgroundColor = option.currentColor
            layoutIfNeeded()
        }
    }

    @IBOutlet fileprivate weak var itemLabel: UILabel!
    @IBOutlet fileprivate weak var currentBarView: UIView!
    @IBOutlet fileprivate weak var currentBarViewHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        currentBarView.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(resetFirstTime), name: Notification.Name(rawValue: "ResetFirstTime"), object: nil)

    }
    @objc func resetFirstTime() {
        isFirstTime = true
        showTipView()
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        if item.count == 0 {
            return CGSize.zero
        }

        return intrinsicContentSize
    }

    func showTipView() {
        if isCurrent == true && item == "SOZIES" {
            //                tipView?.dismiss()
            tipView?.isHidden = false
            if UserDefaultManager.getIfUserGuideShownFor(userGuide: UserDefaultKey.mySoziesUserGuide) == false {
                self.showTipViewSozie()
            }
        } else if isCurrent == true && item == "REQUESTS" {
            tipView?.isHidden = false
            if UserDefaultManager.getIfUserGuideShownFor(userGuide: UserDefaultKey.myRequestsUserGuide) == false {
                self.showTipViewRequests()
            }
        } else {
            tipView?.isHidden = true
        }
    }
    class func cellIdentifier() -> String {
        return "TabCollectionCell"
    }
}

// MARK: - View

extension TabCollectionCell {
    override var intrinsicContentSize: CGSize {
        let width: CGFloat
        if let tabWidth = option.tabWidth, tabWidth > 0.0 {
            width = tabWidth
        } else {
            width = itemLabel.intrinsicContentSize.width + option.tabMargin * 2
        }
        let size = CGSize(width: width, height: option.tabHeight)
        return size
    }

    func hideCurrentBarView() {
        currentBarView.isHidden = true
    }

    func showCurrentBarView() {
        currentBarView.isHidden = false
    }

    func highlightTitle() {
        itemLabel.textColor = option.currentColor
        itemLabel.font = option.font
    }

    func unHighlightTitle() {
        itemLabel.textColor = option.defaultColor
        itemLabel.font = option.font
    }
    func showTipViewRequests() {
        if UserDefaultManager.isUserGuideDisabled() == false {
            if self.item == "REQUESTS" {
                if isFirstTime {
                    let text = "This is where all the requests you have made are kept"
                    var prefer = UtilityManager.tipViewGlobalPreferences()
                    prefer.drawing.arrowPosition = .top
                    prefer.positioning.maxWidth = 110
                    //                prefer.positioning.bubbleVInset = 120
                    tipView = EasyTipView(text: text, preferences: prefer, delegate: nil)
                    tipView?.show(animated: true, forView: self.itemLabel, withinSuperview: self.superview?.superview)
                    isFirstTime = false
                    UserDefaultManager.setUserGuideShown(userGuide: UserDefaultKey.myRequestsUserGuide)
                    perform(#selector(self.dismissTipView), with: nil, afterDelay: 5.0)
                }
            }
        }
    }
    func showTipViewSozie() {
        if UserDefaultManager.isUserGuideDisabled() == false {
            if self.item == "SOZIES" {
                if isFirstTime {
                    let text = "Click here to see your Sozie matches and Sozies that you are following"
                    var prefer = UtilityManager.tipViewGlobalPreferences()
                    prefer.drawing.arrowPosition = .left
                    prefer.positioning.maxWidth = 110
                    //        prefer.positioning.bubbleVInset = 120
                    tipView = EasyTipView(text: text, preferences: prefer, delegate: nil)
                    tipView?.show(animated: true, forView: self.itemLabel, withinSuperview: self.superview?.superview)
                    isFirstTime = false
                    if self.superview?.superview != nil {
                        UserDefaultManager.setUserGuideShown(userGuide: UserDefaultKey.mySoziesUserGuide)
                    }
                    perform(#selector(self.dismissTipView), with: nil, afterDelay: 5.0)                }
            }
        }
    }
    @objc func dismissTipView() {
        tipView?.dismiss()
    }
//    func showTipView() {
//        let text = "After swiping, if you still don't see your size tried on, click above!"
//        var prefer = UtilityManager.tipViewGlobalPreferences()
//        prefer.drawing.arrowPosition = .bottom
//        prefer.positioning.maxWidth = 110
//        prefer.positioning.bubbleVInset = 120
//        let tipView = EasyTipView(text: text, preferences: prefer, delegate: nil)
//        tipView.show(animated: true, forView: self, withinSuperview: self.superview)
//    }
}

// MARK: - IBAction

extension TabCollectionCell {
    @IBAction fileprivate func tabItemTouchUpInside(_ button: UIButton) {
        tabItemButtonPressedBlock?()
    }
}
