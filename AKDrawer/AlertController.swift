//
//  AlertController.swift
//  AKDrawer
//
//  Created by macmini3 on 10/08/19.
//  Copyright © 2019 Gatisofttech. All rights reserved.
//

import UIKit

class AlertController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblAlert: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblAlert.tableFooterView = UIView(frame: .zero)
    }
    
    @IBAction func okTapped(_ sender: UIButton) {
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
    }
    
}
