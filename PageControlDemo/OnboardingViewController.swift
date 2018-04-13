//
//  OnboardingViewController.swift
//  PageControlDemo
//
//  Created by vishalm on 13/04/18.
//  Copyright © 2018 VishalMadheshia. All rights reserved.
//

import UIKit
import SwiftyGif

let data = [["url":"https://media.giphy.com/media/CCWVP77mmtweA/giphy.gif","title":"First Title!","subTitle":"Very first subtitle"],["url":"https://media.giphy.com/media/xT1XGHytddjHlgdsXe/giphy.gif","title":"Second Title","subTitle":"Second subtitle"]]

class OnboardingViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    // MARK: - Variables
    var onboardingModel: OnboardModel = OnboardModel()
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.gifImageView.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.gifImageView.stopAnimating()
    }
    
    // MARK: - Private Methods
    private func setupData() {
        titleLabel.text = onboardingModel.title
        subtitleLabel.text = onboardingModel.subtitle
        gifImageView.setGifFromURL(URL(string: onboardingModel.gifUrl))
    }
    
}
