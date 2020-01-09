//
//  ServiceController.swift
//  AKDrawer
//
//  Created by macmini3 on 14/08/19.
//  Copyright © 2019 Gatisofttech. All rights reserved.
//

import UIKit


class tableCell: UITableViewCell {}

class ServiceController: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    
//    var serviceCall = ServiceCenter()
    
    var tblData = Array<Dictionary<String,Any>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.register(tableCell.self, forCellReuseIdentifier: "tableCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        Services.serviceCallGetWithSync(urlString: "https://reqres.in/api/users?page=1", responseType: .none) { (json, error) in
            if let tempDic = json as? Dictionary<String,Any> {
                self.tblData = tempDic["data"] as! Array<Dictionary<String,Any>>
                DispatchQueue.main.async {
                    self.myTableView.reloadData()
                }
            }
        }
        
        Services.serviceCallGetWithAsync(urlString: "https://reqres.in/api/users?page=2", responseType: .none) { (httpResponse, json, error) in
            print(json!)
        }
        
//        serviceCallGet(urlString: "https://jsonplaceholder.typicode.com/todos/2") { (responseSatues, json, error) in
//            if let data = json {
//
//                self.tblData.append(data)
//                DispatchQueue.main.async {
//                    self.myTableView.reloadData()
//                }
//            }
//        }
    }
}

extension ServiceController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tblData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! tableCell
        cell.textLabel?.text = "\(tblData[indexPath.row]["first_name"] as? String ?? "") \(tblData[indexPath.row]["last_name"] as? String ?? "")"
        cell.imageView?.layer.cornerRadius = cell.imageView!.frame.height / 2
        cell.imageView?.clipsToBounds = true
        cell.imageView?.sd_setImage(with: URL(string: tblData[indexPath.row]["avatar"] as? String ?? ""), placeholderImage: UIImage(named: "profile_default"))
        return cell
    }
}
