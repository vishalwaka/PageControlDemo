//
//  OnboardingPageViewController.swift
//  PageControlDemo
//
//  Created by vishalm on 13/04/18.
//  Copyright © 2018 VishalMadheshia. All rights reserved.
//

import UIKit

class OnboardingPageViewController: UIPageViewController {

    // MARK: - Variables
    var pageControl = UIPageControl()
    var onboardModels: [OnboardModel] = []
    var orderedViewControllers: [UIViewController] = []
    var currentPage: Int = 0 {
        didSet {
            self.pageControl.currentPage = currentPage
        }
    }
    var totalNumberOfPages: Int = 0 {
        didSet {
            self.pageControl.numberOfPages = totalNumberOfPages
        }
    }
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        setOnboardModels()
        setOnboardingVCs()
        // This sets up the first view that will show up on our page control
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        configurePageControl()
        for subview in self.view.subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.delegate = self
                break;
            }
        }
    }
    
    func goToNextScreen(closeScreen: ()->()) {
        guard self.currentPage != totalNumberOfPages - 1 else {
            closeScreen()
            return
        }
        let nextViewController = orderedViewControllers[self.currentPage + 1]
        setViewControllers([nextViewController],
                           direction: .forward,
                           animated: true,
                           completion: { success in
                            guard success else { return }
                            self.currentPage = self.currentPage + 1
        })
        
    }
    
    func setOnboardModels() {
        for dataItem in data {
            let onboardModel = OnboardModel(title: dataItem["title"]!, subtitle: dataItem["subTitle"]!, gifUrl: dataItem["url"]!)
            onboardModels.append(onboardModel)
        }
    }
    
    func setOnboardingVCs() {
        for onboardModel in onboardModels {
            let onboardVC = getOnboardingVC()
            onboardVC.onboardingModel = onboardModel
            orderedViewControllers.append(onboardVC)
        }
    }
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        
        self.totalNumberOfPages = orderedViewControllers.count
        self.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.currentPageIndicatorTintColor = .black
        self.view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    func getOnboardingVC() -> OnboardingViewController {
        return storyboard!.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension OnboardingPageViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (currentPage == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width) {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0);
        } else if (currentPage == totalNumberOfPages - 1 && scrollView.contentOffset.x > scrollView.bounds.size.width) {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0);
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if (currentPage == 0 && scrollView.contentOffset.x <= scrollView.bounds.size.width) {
            targetContentOffset.pointee = CGPoint(x: scrollView.bounds.size.width, y: 0);
        } else if (currentPage == totalNumberOfPages - 1 && scrollView.contentOffset.x >= scrollView.bounds.size.width) {
            targetContentOffset.pointee = CGPoint(x: scrollView.bounds.size.width, y: 0);
        }
    }
}

extension OnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.currentPage = orderedViewControllers.index(of: pageContentViewController)!
    }
    
}

extension OnboardingPageViewController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right.
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left.
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    // Enables pagination dots
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
