//
//  ViewController.swift
//  testCrossView
//
//  Created by macmini3 on 08/08/19.
//  Copyright © 2019 Gatisofttech. All rights reserved.
//

import UIKit

class AnimateController: UIViewController {

    @IBOutlet weak var btnAlert: UIButton!
    @IBOutlet weak var slidingTextLabel: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(Anim), userInfo: nil, repeats: false)
    }
    
    override func viewWillLayoutSubviews() {
        btnAlert.layer.cornerRadius = btnAlert.bounds.height / 2
    }
    
    @objc func Anim() {
        self.slidingTextLabel.slideInFromLeft(30.0)
    }
    
    @IBAction func alertTapped(_ sender: UIButton) {
        if #available(iOS 10.0, *) {
            let AlertVC = AlertController(nibName: "AlertController", bundle: nil)
            AlertVC.view.frame = UIScreen.main.bounds
            
            UIApplication.shared.keyWindow?.addSubview(AlertVC.view)
            self.addChild(AlertVC)
            didMove(toParent: AlertVC)
            
            AlertVC.addAction(title: "Blah Blah", dataSource: ["Objective - C","Swift","Java","Kotlin","R Language","Ruby on Rails","JavaScript"] as [AnyObject]) { (selection) in
                self.btnAlert.setTitle(selection, for: .normal)
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    
}

extension UIView {
    func slideInFromLeft(_ duration: TimeInterval) {
        let slideInFromLeftTransition = CATransition()
        slideInFromLeftTransition.repeatCount = Float.infinity
        slideInFromLeftTransition.type = CATransitionType.push
        slideInFromLeftTransition.subtype = CATransitionSubtype.fromLeft
        slideInFromLeftTransition.duration = duration
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        self.layer.add(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
    }
}
