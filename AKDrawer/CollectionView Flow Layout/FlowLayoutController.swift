//
//  FlowLayoutController.swift
//  AKDrawer
//
//  Created by macmini3 on 20/08/19.
//  Copyright © 2019 Gatisofttech. All rights reserved.
//

import UIKit

class FlowLayoutController: UIViewController {

    @IBOutlet weak var colCollection: UICollectionView!
    
    var numberOfColumns = Int()
    var flowLayout = UICollectionViewFlowLayout()
    var spacing = CGFloat()
    var marginAndInsets = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flowLayout = colCollection.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.sectionInset.top = 8
        flowLayout.sectionInset.left = 8
        flowLayout.sectionInset.right = 8
        flowLayout.sectionInset.bottom = 8
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 8
        colCollection.register(UINib(nibName: "CollectionCVCell", bundle: nil), forCellWithReuseIdentifier: "CollectionCVCell")
    }
    
}

extension FlowLayoutController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colCollection.dequeueReusableCell(withReuseIdentifier: "CollectionCVCell", for: indexPath) as! CollectionCVCell
        cell.imgJewellery.image = #imageLiteral(resourceName: "profile_default")
        cell.lblTitle.text = "Jewellery - \(indexPath.row + 1)"
        cell.backgroundColor = UIColor.white
        cell.layer.cornerRadius = 8.0
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 0.0
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        cell.layer.masksToBounds = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            numberOfColumns = 3
        } else {
            numberOfColumns = 2
        }
        
        spacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumInteritemSpacing : flowLayout.minimumLineSpacing
        marginAndInsets = (flowLayout.sectionInset.left + flowLayout.sectionInset.right) + (spacing * (CGFloat(numberOfColumns) - 1))
        
        let itemWidth : CGFloat = (colCollection.frame.width - marginAndInsets) / CGFloat(numberOfColumns)
        let size = CGSize(width: itemWidth, height: itemWidth + 10) //194
        
        return size
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let animation = CATransform3DTranslate(CATransform3DIdentity, 0, 10, 0)
        cell.layer.transform = animation
        cell.alpha = 0
        UIView.animate(withDuration: 0.5) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
}
