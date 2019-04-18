//
//  WelcomePageVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 4/13/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

protocol WelcomeButtonActionsDelegate: class {
    func nextButtonTapped()
    func skipButtonTapped()
    func shopTogetherButtonTapped()
}
protocol WelcomeModel {
    var delegate: WelcomeButtonActionsDelegate? {get set}
}
protocol IndexProviding {
    var index: Int {get set}
}
protocol PageControlIndexProviding: class {
    func pageChanged(index: Int)
}
class WelcomePageVC: UIPageViewController {

    private lazy var orderedViewControllers: [UIViewController] = []
    var currentIndex = 0
    var pendingIndex = 0
    weak var pageDelegate: PageControlIndexProviding?
    var userType: UserType?
    var signUpDict: [String: Any]?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataSource = self
        delegate = self
        if userType == UserType.sozie {
            orderedViewControllers = [self.viewCntrollerWith(identifier: "FirstSozieWelcomeVC"), self.viewCntrollerWith(identifier: "SecondSozieWelcomeVC"), self.viewCntrollerWith(identifier: "ThirdSozieWelcomeVC")] as! [UIViewController]
        } else {
            orderedViewControllers = [self.viewCntrollerWith(identifier: "FirstShopperWelcomeVC"), self.viewCntrollerWith(identifier: "SecondShopperWelcomeVC"), self.viewCntrollerWith(identifier: "ThirdShopperWelcomeVC")] as! [UIViewController]
        }
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        for viewController in orderedViewControllers {
            if var currentVC = viewController as? WelcomeModel {
                currentVC.delegate = self
            }
        }
    }
    private func viewCntrollerWith(identifier: String) -> UIViewController? {
        return self.storyboard?.instantiateViewController(withIdentifier: identifier)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if var signUpInfoProvider = segue.destination as? SignUpInfoProvider {
            signUpInfoProvider.signUpInfo = signUpDict
        }
    }

    func getIndexOfController(viewController: UIViewController) -> Int? {
        for index in 0..<orderedViewControllers.count where orderedViewControllers[index] == viewController {
            return index
        }
        return nil
    }

    func changePage(direction: NavigationDirection) {
        if let vcs = self.viewControllers {
            if let currentVC = vcs[0] as? IndexProviding {
                var pageIndex = currentVC.index
                if direction == .forward {
                    pageIndex = pageIndex + 1
                } else {
                    pageIndex = pageIndex - 1
                }
                let viewController = orderedViewControllers[pageIndex]
                currentIndex = pageIndex
                self.pageDelegate?.pageChanged(index: currentIndex)
                self.setViewControllers([viewController], direction: direction, animated: true, completion: nil)
            }
        }
    }
}

extension WelcomePageVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.getIndexOfController(viewController: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        return orderedViewControllers[nextIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.getIndexOfController(viewController: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        return orderedViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let index = (pendingViewControllers[0] as? IndexProviding)?.index {
            pendingIndex = index
        }
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentIndex = pendingIndex
            self.pageDelegate?.pageChanged(index: currentIndex)
        }
    }
}

extension WelcomePageVC: WelcomeButtonActionsDelegate {
    func nextButtonTapped() {
        changePage(direction: .forward)
    }

    func skipButtonTapped() {
        if userType == UserType.sozie {
            performSegue(withIdentifier: "toWorkVC", sender: self)
        } else {
            performSegue(withIdentifier: "toSignUpEmailVC", sender: self)
        }
    }

    func shopTogetherButtonTapped() {
        if userType == UserType.sozie {
            performSegue(withIdentifier: "toWorkVC", sender: self)
        } else {
            performSegue(withIdentifier: "toSignUpEmailVC", sender: self)
        }
    }
}
extension WelcomePageVC: SignUpInfoProvider {
    var signUpInfo: [String: Any]? {
        get { return signUpDict }
        set (newInfo) {
            signUpDict = newInfo
        }
    }
}
