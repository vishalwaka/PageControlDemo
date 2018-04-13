//
//  OnboardContainerViewController.swift
//  PageControlDemo
//
//  Created by vishalm on 13/04/18.
//  Copyright © 2018 VishalMadheshia. All rights reserved.
//

import UIKit

class OnboardContainerViewController: UIViewController {

    var pageVC: OnboardingPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "onboard_page_segue", let pageVC = segue.destination as? OnboardingPageViewController {
            self.pageVC = pageVC
        }
    }
    
    // MARK: - Private methods
    private func dismiss() {
        dismiss(animated: true, completion: nil)
        print("Close")
    }
    
    private func goToNextScreen() {
        pageVC?.goToNextScreen(){
            dismiss()
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func skipButtonAction(_ sender: Any) {
        //Close screen
        dismiss()
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        //Go to next screen or close on last page.
        goToNextScreen()
    }
}
