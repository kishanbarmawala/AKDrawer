//
//  ViewController.swift
//  AKDrawer
//
//  Created by macmini3 on 07/08/19.
//  Copyright © 2019 Gatisofttech. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class ViewController: UIViewController {
    
    //MARK:- IBOUTLETS
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var btnDD: UIButton!
    
    //MARK:- DECLARATIONS
    
    var menuVC = SidemenuController()
    var dimView = UIView()
    var viewForLoader = UIView()
    
    var ddTableView : UITableView = {
        let tempdd = UITableView()
        tempdd.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        tempdd.register(ddCell.self, forCellReuseIdentifier: "DDCELL")
        tempdd.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "DDHEADCELL")
        tempdd.keyboardDismissMode = .onDrag
        return tempdd
    }()
    
    var ddDataSource = Array<String>()
    var ddCellHeight: CGFloat = 40
    var selectionBtn = UIButton()
    var searchResult = String()
    
    //MARK:- VIEW_METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ddTableView.delegate = self
        ddTableView.dataSource = self
        
        btnDD.addTarget(self, action: #selector(DDTapped(_:)), for: .touchUpInside)
        
        menuVC = self.storyboard!.instantiateViewController(withIdentifier: "MENU") as! SidemenuController
        menuVC.SideMenuHeaderArr = ["Home & Loader","Service","Animation, Alert & Calender","CollectionView Flow Layout","Privacy Policy","Education","Other"]
//        menuVC.SideMenuDataArr = [["Hi","Hello"],[],[],[],[],[]]
        
        menuVC.menuSelection = { selection in
            if selection[0] == 2 { self.navigationController?.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "SERVICE"), animated: true)
            }
            else if selection[0] == 3 { self.navigationController?.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "ANIMATE"), animated: true)
            }
            else if selection[0] == 4 { self.navigationController?.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "FLOW"), animated: true)
            }
            else if selection[0] == 7 { self.navigationController?.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "OTHER"), animated: true)
            }
        }
        gradientView.addGradient(colors: [UIColor.red.cgColor, UIColor.blue.cgColor], direction: .vertical)
        
    }
    
    override func viewWillLayoutSubviews() {
        gradientView.layer.cornerRadius = 12.0
        gradientView.clipsToBounds = true
    }
    
    //MARK:- FUNCTIONS
    
    @objc func DDTapped(_ sender: UIButton) {
        selectionBtn = sender
        showDD(frames: sender.frame, dataSource: ["Objective - C","Swift","Java","Kotlin","R Language","Ruby on Rails","JavaScript"])
    }
    
    func showDD(frames: CGRect, dataSource: Array<Any>) {
        
        dimView = UIView()
        // dimView.isHidden = false
        dimView.frame = UIApplication.shared.keyWindow?.frame ?? self.view.frame
        self.view.addSubview(dimView)
        
        ddDataSource = dataSource as! [String]
        ddTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(ddTableView)
        ddTableView.layer.cornerRadius = 8.0
        
        searchResult = ""
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        ddTableView.reloadData()
        
        let ddOutTap = UITapGestureRecognizer(target: self, action: #selector(hideDD))
        dimView.addGestureRecognizer(ddOutTap)
        dimView.alpha = 0
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.dimView.alpha = 0.5
            self.ddTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 4, width: frames.width, height: self.ddCellHeight * CGFloat(self.ddDataSource.count) + 65.0)
        }, completion: nil)
    }
    
    @objc func hideDD() {
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.dimView.alpha = 0
            self.ddTableView.frame = CGRect(x: self.selectionBtn.frame.origin.x, y: self.selectionBtn.frame.origin.y + self.selectionBtn.frame.height, width: self.selectionBtn.frame.width, height: 0)
            self.dimView.endEditing(true)
            self.view.endEditing(true)
        }, completion: nil)
    }
    
    func showPulseWithMic() {
        
        dimView = UIView()
        // dimView.isHidden = false
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
        // dimView.isHidden = true
        dimView.backgroundColor = UIColor.clear
        dimView.removeFromSuperview()
    }
    
    //MARK:- BUTTON_ACTIONS
    
    @IBAction func sideMenuTapped(_ sender: UIBarButtonItem) {
        menuVC.revealSideMenu()
    }

    @IBAction func pulsingButtonTapped(_ sender: UIButton) {
        showPulseWithMic()
    }
    
    @IBAction func animateLoaderTapped(_ sender: UIButton) {
        showLoader()
    }
    
    func showLoader() {
        dimView = UIView()
        // dimView.isHidden = false
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        dimView.frame = UIScreen.main.bounds
        dimView.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2)
        
        viewForLoader = UIView()
        viewForLoader.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        viewForLoader.layer.position = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2)
        viewForLoader.backgroundColor = UIColor.clear
        dimView.addSubview(viewForLoader)
        
        let imageToShow = UIImageView(image: #imageLiteral(resourceName: "KImage"))
        imageToShow.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        imageToShow.contentMode = UIView.ContentMode.scaleAspectFit
        imageToShow.layer.cornerRadius = imageToShow.bounds.height / 2
        imageToShow.clipsToBounds = true
        imageToShow.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2)
        
        let lblRotate = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
        lblRotate.text = "Kishan ... Barmawala ..."
        lblRotate.textColor = .white//UIColor(red: 238/255, green: 67/255, blue: 102/255, alpha: 1.0)
        lblRotate.font = UIFont.systemFont(ofSize: 20)
        lblRotate.layer.position = CGPoint(x: viewForLoader.bounds.size.width / 2, y: viewForLoader.bounds.size.height / 2)
        lblRotate.backgroundColor = .clear
        viewForLoader.addSubview(lblRotate)
        
        let arrForLabel = decompose(lbl: lblRotate)
        
        let tempLabel = tapLabelAnimation(arrLabel: arrForLabel)
        
        UIView.rz_run(tempLabel)
        
        let horizontalRotation = CABasicAnimation(keyPath: "transform.rotation.y")
        horizontalRotation.fromValue = 0
        horizontalRotation.toValue = Double.pi * 2
        horizontalRotation.duration = 1.7
        horizontalRotation.repeatCount = Float.infinity
        imageToShow.layer.add(horizontalRotation, forKey: "Spin")
        
        let circularRotation = CABasicAnimation(keyPath: "transform.rotation")
        circularRotation.fromValue = 0
        circularRotation.toValue = Double.pi * 2
        circularRotation.duration = 6.5
        circularRotation.repeatCount = Float.infinity
        viewForLoader.layer.add(circularRotation, forKey: "Spin")
        
        dimView.addSubview(imageToShow)
        
        UIApplication.shared.keyWindow?.addSubview(dimView)
        
        Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(hideLoader), userInfo: nil, repeats: false)
        
    }
    
    @objc func hideLoader() {
        dimView.backgroundColor = UIColor.clear
        dimView.removeFromSuperview()
    }
    
    func tapLabelAnimation(arrLabel: Array<UILabel>) -> RZViewAction {
        
        var circle = Array<RZViewAction>()
        
        let radius : CGFloat = 4.3 * CGFloat(arrLabel.count)
        let angleIncrement : CGFloat = 2.0 * CGFloat.pi / CGFloat(arrLabel.count)
        
        for (idx,letter) in arrLabel.enumerated() {
            
            let angle = CGFloat(idx) * CGFloat(angleIncrement)
            let x : CGFloat = radius * CGFloat(cosf(Float(angle)))
            let y : CGFloat = radius * CGFloat(sinf(Float(angle)))
            
            let circleTrans : RZViewAction = RZViewAction({
                letter.transform = CGAffineTransform(rotationAngle: CGFloat(angle - CGFloat.pi))
                letter.center = CGPoint(x: self.viewForLoader.bounds.width / 2 - x, y: self.viewForLoader.bounds.height / 2 - y)
            }, with: .curveEaseIn, duration: 0.7)
            
            circle.append(circleTrans)
            
        }
        let circleGroup = RZViewAction.group(circle)
        
        return RZViewAction.sequence([circleGroup])
    }
    
    func decompose(lbl: UILabel) -> Array<UILabel> {
        
        let whitespace = CharacterSet()
        var wordLabels = Array<UILabel>()
        
        var letterX = lbl.frame.origin.x
        
        for i in 0..<lbl.text!.count {
            
            let word = lbl.text!.substring(from: i, length: 1)
            let size = word.size(withAttributes: [.font: lbl.font!])
            
            if !whitespace.contains(String(word).unicodeScalars.first!) {
                
                let singleWordLabel = UILabel()
                singleWordLabel.frame.origin.x = letterX
                singleWordLabel.frame.size = size
                singleWordLabel.font = lbl.font
                singleWordLabel.textColor = lbl.textColor
                singleWordLabel.text = word
                singleWordLabel.center = CGPoint(x: singleWordLabel.center.x, y: lbl.center.y)
                
                lbl.superview?.insertSubview(singleWordLabel, aboveSubview: lbl)
                wordLabels.append(singleWordLabel)
            }
            letterX += size.width
        }
        lbl.removeFromSuperview()
        return wordLabels
    }
    
    @objc func searchTapped(_ sender:UIButton) {
        print("tapped")
    }
    
}

@available(iOS 10.0, *)
extension ViewController: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, AKSearchDelegate {
    
    func textFieldSearch(result: String) {
        print("My Result ::: \(result)")
        searchResult = result
        if result.count != 0 {
            ddDataSource = ["Objective - C","Swift","Java","Kotlin","R Language","Ruby on Rails","JavaScript"].filter({ ($0.localizedCaseInsensitiveContains(result) || $0.localizedCaseInsensitiveContains(result)) }).map({ $0 })
            
        } else {
            ddDataSource = ["Objective - C","Swift","Java","Kotlin","R Language","Ruby on Rails","JavaScript"]
        }
        ddTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ddDataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: ddTableView.frame.width, height: 65.0))
        headerView.backgroundColor = .white
        let searchField = SearchTextField()
        searchField.text = searchResult
        searchField.frame = CGRect(x: 8, y: 12, width: headerView.frame.width - 16, height: headerView.frame.height - 24)
        searchField.searchDelegate = self
        headerView.addSubview(searchField)
        return headerView
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(string)
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ddCellHeight
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

extension String {
    
    func substring(from: Int?, to: Int?) -> String {
        if let start = from { guard start < self.count else { return "" } }
        
        if let end = to { guard end >= 0 else { return "" } }
        
        if let start = from, let end = to { guard end - start >= 0 else { return "" } }
        
        let startIndex: String.Index
        if let start = from, start >= 0 {
            startIndex = self.index(self.startIndex, offsetBy: start)
        } else { startIndex = self.startIndex }
        
        let endIndex: String.Index
        if let end = to, end >= 0, end < self.count {
            endIndex = self.index(self.startIndex, offsetBy: end + 1)
        } else { endIndex = self.endIndex }
        
        return String(self[startIndex ..< endIndex])
    }
    
    func substring(from: Int?, length: Int) -> String {
        guard length > 0 else { return "" }
        
        let end: Int
        if let start = from, start > 0 { end = start + length - 1 } else { end = length - 1 }
        
        return self.substring(from: from, to: end)
    }
}

extension UIView {
    enum Direction {
        case horizontal
        case vertical
    }
    func addGradient(colors: [CGColor], direction: Direction) {
        let gradeLayer = CAGradientLayer()
        gradeLayer.colors = colors//[UIColor.red.cgColor, UIColor.blue.cgColor]
        switch direction {
        case .horizontal:
            gradeLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradeLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        case .vertical:
            gradeLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradeLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        }
        gradeLayer.frame = self.bounds
        self.layer.insertSublayer(gradeLayer, at: 0)
    }
}

