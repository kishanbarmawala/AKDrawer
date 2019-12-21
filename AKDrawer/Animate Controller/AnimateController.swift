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
        //ghadfkjg
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
    @IBAction func calenderTapped(_ sender: UIButton) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let startDate = formatter.date(from: "2001/01/01")
        
//        let dateRangePickerViewController = CalendarDateRangePickerViewController(collectionViewLayout: UICollectionViewFlowLayout())
//        dateRangePickerViewController.delegate = self
//        dateRangePickerViewController.minimumDate = startDate
//        dateRangePickerViewController.maximumDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())
//
//        dateRangePickerViewController.selectedStartDate = Date()
//        dateRangePickerViewController.selectedEndDate = Calendar.current.date(byAdding: .day, value: 10, to: Date())
//        dateRangePickerViewController.selectedColor = UIColor.red
//        dateRangePickerViewController.titleText = "Select Date Range"
//
//        let navigationController = UINavigationController(rootViewController: dateRangePickerViewController)
//        self.navigationController?.present(navigationController, animated: true, completion: nil)
        
        let CalenderVC = self.storyboard!.instantiateViewController(withIdentifier: "CALENDER") as! CalenderController
        
        CalenderVC.delegate = self
        CalenderVC.minimumDate = startDate
        CalenderVC.maximumDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())
        
        CalenderVC.selectedStartDate = Date()
        CalenderVC.selectedEndDate = Calendar.current.date(byAdding: .day, value: 10, to: Date())
        CalenderVC.selectedColor = UIColor(red: 102/255, green: 153/255, blue: 255/255, alpha: 1.0)
        CalenderVC.titleText = "Select Date Range"
        
        
        CalenderVC.view.frame = UIScreen.main.bounds
        UIApplication.shared.keyWindow?.addSubview(CalenderVC.view)
        self.addChild(CalenderVC)
        didMove(toParent: CalenderVC)
        
    
    }
}
extension AnimateController : CalendarDateRangePickerViewControllerDelegate {
    
    func didCancelPickingDateRange() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func didPickDateRange(startDate: Date!, endDate: Date!) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
//        label.text = dateFormatter.string(from: startDate) + " to " + dateFormatter.string(from: endDate)
        print(dateFormatter.string(from: startDate) + " to " + dateFormatter.string(from: endDate))
        self.navigationController?.dismiss(animated: true, completion: nil)
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
