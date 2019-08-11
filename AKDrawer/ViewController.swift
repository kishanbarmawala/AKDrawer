//
//  ViewController.swift
//  AKDrawer
//
//  Created by macmini3 on 07/08/19.
//  Copyright © 2019 Gatisofttech. All rights reserved.
//

import UIKit

class ddCell: UITableViewCell {
    
}

class ViewController: UIViewController {
    
    //MARK:- IBOUTLETS
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var btnDD: UIButton!
    
    //MARK:- DECLARATIONS
    
    var menuVC = SidemenuController()
    var dimView = UIView()
    var ddTableView : UITableView = {
        let tempdd = UITableView()
        tempdd.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        tempdd.register(ddCell.self, forCellReuseIdentifier: "DDCELL")
        return tempdd
    }()
    var ddDataSource = Array<String>()
    var ddCellHeight: CGFloat = 40
    var selectionBtn = UIButton()
    
    //MARK:- VIEW_METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ddTableView.delegate = self
        ddTableView.dataSource = self
        menuVC = self.storyboard!.instantiateViewController(withIdentifier: "MENU") as! SidemenuController
        btnDD.addTarget(self, action: #selector(DDTapped(_:)), for: .touchUpInside)
//        NotificationCenter.default.addObserver(self, selector: #selector(sideMenuClickEvent(_:)), name: Notification.Name("SideMenuTap"), object: nil)
        
        menuVC.menuSelection = { selection in
            print(selection)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let gradeLayer = CAGradientLayer()
        gradeLayer.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        gradeLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradeLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradeLayer.frame = gradientView.bounds
        gradientView.layer.insertSublayer(gradeLayer, at: 0)
        
    }
    
    //MARK:- FUNCTIONS
    
    @objc func DDTapped(_ sender: UIButton) {
        selectionBtn = sender
        showDD(frames: sender.frame, dataSource: ["Objective - C","Swift","Java","Kotlin","R Language","Ruby on Rails","JavaScript"])
    }
    
    func showDD(frames: CGRect, dataSource: Array<Any>) {
        
        dimView = UIView()
        dimView.isHidden = false
        dimView.frame = UIApplication.shared.keyWindow?.frame ?? self.view.frame
        self.view.addSubview(dimView)
        ddDataSource = dataSource as! [String]
        ddTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(ddTableView)
        ddTableView.layer.cornerRadius = 8.0
        
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        ddTableView.reloadData()
        let ddOutTap = UITapGestureRecognizer(target: self, action: #selector(hideDD))
        
        dimView.addGestureRecognizer(ddOutTap)
        dimView.alpha = 0
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.dimView.alpha = 0.5
            self.ddTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 4, width: frames.width, height: self.ddCellHeight * CGFloat(self.ddDataSource.count))
        }, completion: nil)
    }
    
    @objc func hideDD() {
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.dimView.alpha = 0
            self.ddTableView.frame = CGRect(x: self.selectionBtn.frame.origin.x, y: self.selectionBtn.frame.origin.y + self.selectionBtn.frame.height, width: self.selectionBtn.frame.width, height: 0)
        }, completion: nil)
    }
    
    func showPulseWithMic() {
        
        dimView = UIView()
        dimView.isHidden = false
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        dimView.frame = UIScreen.main.bounds
        dimView.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2)
        
        let imgMic = UIImageView(image: #imageLiteral(resourceName: "mic_icon"))
        imgMic.backgroundColor = .white
        imgMic.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        imgMic.contentMode = .scaleAspectFit
        imgMic.center = dimView.center
        imgMic.layer.cornerRadius = 25.0
        
        let pulse = PulseAnimation(numberOfPulses: Float.infinity, radius: 200, position: dimView.center)
        pulse.animationDuration = 1.0
        pulse.backgroundColor = UIColor(red: 238/255, green: 67/255, blue: 102/255, alpha: 1.0).cgColor
        
        dimView.layer.insertSublayer(pulse, below: imgMic.layer)
        dimView.addSubview(imgMic)
        UIApplication.shared.keyWindow?.addSubview(dimView)
        
        // call HidePulse for manually to stop pulsing
        // And comment below line
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(hidePulse), userInfo: nil, repeats: false)
    }
    
    @objc func hidePulse() {
        dimView.isHidden = true
        dimView.backgroundColor = UIColor.clear
        dimView.removeFromSuperview()
    }
    
    
 /*   @objc func sideMenuClickEvent(_ notification: Notification?) {
        let indexo = notification?.object as! Array<Int>
        print(indexo)
    }*/
    
    //MARK:- BUTTON_ACTIONS
    
    @IBAction func sideMenuTapped(_ sender: UIBarButtonItem) {
        // Present Below NavigationView
//        self.view.addSubview(menuVC.view)
//        self.addChild(menuVC)

        // Present Over NavigationView
        UIApplication.shared.keyWindow?.addSubview(menuVC.view)
        
        menuVC.view.layoutIfNeeded()
        
        menuVC.view.frame = CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.menuVC.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }, completion: nil)
        
        menuVC.view.layoutIfNeeded()
    }

    @IBAction func pulsingButtonTapped(_ sender: UIButton) {
        showPulseWithMic()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ddDataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DDCELL", for: indexPath) as! ddCell
        cell.textLabel?.text = ddDataSource[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        btnDD.setTitle(ddDataSource[indexPath.row], for: .normal)
        hideDD()
    }
}

