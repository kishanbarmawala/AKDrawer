//
//  AutoResizingController.swift
//  AKDrawer
//
//  Created by Kishan Barmawala on 30/11/19.
//  Copyright © 2019 Gatisofttech. All rights reserved.
//

import UIKit

class AutoResizingController: UIViewController {
    
    @IBOutlet var resizeCol: UICollectionView!
    
    var arrData : [String] = ["To celebrate and thank the fans who have invested so deeply in the MCU, the filmmakers and talent from Marvel Studios' Avengers: Endgame will visit nine U.S. cities in July and August to treat fans at each tour stop.","The film's development began when Marvel Studios received a loan from Merrill Lynch in April 2005.","The film received praise for Whedon's direction and screenplay, visual effects, action sequences, acting, and musical score, and garnered numerous awards and nominations including Academy Award and BAFTA nominations for achievements in visual effects."]
    
    
    var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.size.width
        layout.estimatedItemSize = CGSize(width: width, height: 10)
        return layout
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 12, left: 0, bottom: 4, right: 0)
        resizeCol.collectionViewLayout = layout
        resizeCol.register(UINib(nibName: "ResizingCVCell", bundle: nil), forCellWithReuseIdentifier: "ResizingCVCell")
        resizeCol.delegate = self
        resizeCol.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resizeCol.reloadData()
    }
    
    
}

extension AutoResizingController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = resizeCol.dequeueReusableCell(withReuseIdentifier: "ResizingCVCell", for: indexPath) as? ResizingCVCell else { return UICollectionViewCell() }
        cell.lblTitle.text = arrData[indexPath.item]
        cell.backView.layer.cornerRadius = 8
        cell.backView.clipsToBounds = true
        cell.addShadow()
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}
