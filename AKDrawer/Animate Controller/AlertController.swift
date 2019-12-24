//
//  AlertController.swift
//  AKDrawer
//
//  Created by macmini3 on 20/08/19.
//  Copyright © 2019 Gatisofttech. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class AlertController: UIViewController {

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblAlert: UITableView!
    
    var tblData = Array<AnyObject>()
//    typealias tempSelection = ((String) -> ())?
    var selection: ((String) -> ())?
    var tempInt = Int()
    let searchField = SearchTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tblData = ["Objective - C","Swift","Java","Kotlin","R Language","Ruby on Rails","JavaScript"] as [AnyObject]
        tblAlert.register(ddCell.self, forCellReuseIdentifier: "tableCell")
        tblAlert.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.6, options: .allowUserInteraction, animations: {
            self.view.transform = .identity
        }, completion: nil)
        
    }
    
    override func viewWillLayoutSubviews() {
        backView.layer.cornerRadius = 8.0
        outerView.layer.cornerRadius = 8.0
        outerView.layer.shadowColor = UIColor.lightGray.cgColor
        outerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        outerView.layer.shadowRadius = 8.0
        outerView.layer.shadowOpacity = 0.6
    }
    
    func addAction(title: String, dataSource: Array<AnyObject>, completionHandler: ((String) -> ())?) {
        lblTitle.text = title
        tblData = dataSource
        selection = completionHandler
        tblAlert.reloadData()
    }
    
    @IBAction func okTapped(_ sender: UIButton) {
        selection?(tblData[tempInt] as! String)
        hideView()
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        hideView()
    }
    
    func hideView() {
        self.view.transform = .identity
        UIView.animate(withDuration: 0.3, animations: {
            self.view.backgroundColor = .clear
            self.view.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }, completion: { (Bool) in
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }
}

@available(iOS 10.0, *)
extension AlertController: UITableViewDelegate, UITableViewDataSource, AKSearchDelegate {
    
    func textFieldSearch(result: String) {
        searchField.text = result
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tblData.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 65.0))
        headerView.backgroundColor = .white
        
        searchField.frame = CGRect(x: 16, y: 12, width: headerView.frame.width - 32, height: headerView.frame.height - 24)
        searchField.searchDelegate = self
        headerView.addSubview(searchField)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblAlert.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! ddCell
        cell.textLabel?.text = tblData[indexPath.row] as? String
        cell.selectionStyle = .none
        if tempInt == indexPath.row {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tempInt = indexPath.row
        tblAlert.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tblAlert.reloadData()
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        tblAlert.reloadData()
    }
    
}
