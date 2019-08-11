//
//  SidemenuController.swift
//  AKDrawer
//
//  Created by macmini3 on 07/08/19.
//  Copyright © 2019 Gatisofttech. All rights reserved.
//

import UIKit

class SidemenuController: UIViewController {
    
    //MARK:- IBOUTLETS
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var colSidemenu: UICollectionView!
    
    //MARK:- DECLARATIONS
    
    var SideMenuHeaderArr = ["Home","Jewellery","About Us","Events","Privacy Policy","Education"]
    
    var SideMenuDataArr = [[],["4","5","6"],[],[],[],[]]
    var isCollapsible = Array<Bool>()//[true,true,true,true,true,true]     //true = to show by default expanded and collapsed
    var indexo = [1,1]
    var menuSelection: ((Array<Int>)->())?
    
    //MARK:- VIEW_METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colSidemenu.register(UINib(nibName: "HeaderCVCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCVCell")
        colSidemenu.register(UINib(nibName: "MenuCVCell", bundle: nil), forCellWithReuseIdentifier: "MenuCVCell")
        for _ in 0..<SideMenuHeaderArr.count {
            isCollapsible.append(true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.view.layer.shadowColor = UIColor.lightGray.cgColor
        self.view.layer.shadowOffset = CGSize(width: 4.0, height: 0.0)
        self.view.layer.shadowRadius = 4.0
        self.view.layer.shadowOpacity = 0.4
        imgUser.layer.cornerRadius = imgUser.frame.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        colSidemenu.reloadData()
    }
    
    //MARK:- FUNCTIONS
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        let point = touches.first!.location(in: self) // to get your touch point in view
        if touches.first!.view == self.view {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.view.frame = CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            }, completion:nil)
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        isCollapsible[sender.view!.tag] = !isCollapsible[sender.view!.tag]
        colSidemenu.reloadSections(IndexSet(integer: sender.view!.tag))
        indexo[1] = 0
        indexo[0] = sender.view!.tag + 1
        
        if !(SideMenuDataArr[indexo[0] - 1].count >= 1) {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.view.frame = CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            }, completion:nil)
        }
        menuSelection?(indexo)
//        NotificationCenter.default.post(name: Notification.Name("SideMenuTap"), object: indexo)
    }
    
    //MARK:- BUTTON_ACTIONS
    
    @IBAction func signInTapped(_ sender: UIButton) {
        print("Sign In")
    }
    
    @IBAction func needHelpTapped(_ sender: UIButton) {
        print("Need Help")
    }
}

extension SidemenuController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SideMenuHeaderArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isCollapsible[section] == true { return 0 }
        else { return SideMenuDataArr[section].count }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: colSidemenu.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = colSidemenu.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCVCell", for: indexPath) as! HeaderCVCell
        
        let headerTap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        headerView.tag = indexPath.section
        headerView.addGestureRecognizer(headerTap)
        headerView.lblTitle.text = SideMenuHeaderArr[indexPath.section]
        
        if indexPath.section % 2 == 0 {
            headerView.backgroundColor = UIColor.white
        } else {
            headerView.backgroundColor = UIColor(red: 245/255, green: 247/255, blue: 248/255, alpha: 1.0)
        }
        headerView.imgArrow.isHidden = true
        headerView.lblTitle.textColor = UIColor.black
        
        if SideMenuDataArr[indexPath.section].count != 0 {
            headerView.imgArrow.isHidden = false
            if isCollapsible[indexPath.section] {
                UIView.animate(withDuration: 1) {
                    headerView.imgArrow.transform = CGAffineTransform.identity
                }
                headerView.lblTitle.textColor = UIColor.black
            } else {
                UIView.animate(withDuration: 1) {
                    headerView.imgArrow.transform = CGAffineTransform(rotationAngle: .pi)
                    
                }
                headerView.lblTitle.textColor = .lightGray
            }
        }
        return headerView
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = colSidemenu.dequeueReusableCell(withReuseIdentifier: "MenuCVCell", for: indexPath) as! MenuCVCell
        cell.lblTitle.text = SideMenuDataArr[indexPath.section][indexPath.row]
        if indexPath.section % 2 == 0 {
            cell.contentView.backgroundColor = UIColor.white
        } else {
            cell.contentView.backgroundColor = UIColor(red: 245/255, green: 247/255, blue: 248/255, alpha: 1.0)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indexo[1] = indexPath.row + 1
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }, completion:nil)
        menuSelection?(indexo)
        //        NotificationCenter.default.post(name: Notification.Name("SideMenuTap"), object: indexo)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: colSidemenu.bounds.size.width, height: 50.0)
    }
    
}
