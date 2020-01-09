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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = colCollection.cellForItem(at: indexPath)
        cell!.rippleEffect(completion: nil)
    }
}

extension UIView {
    func rippleEffect(effectColor: UIColor? = UIColor.lightGray,effectTime: Double? = 0.6 , completion: (() -> Void)?) {
        // Creates a circular path around the view
        let maxSizeBoundry = max(self.bounds.size.width, self.bounds.size.height)
        
        let path = UIBezierPath(ovalIn: CGRect(x: maxSizeBoundry / 4, y: maxSizeBoundry / 4, width: maxSizeBoundry / 2, height: maxSizeBoundry / 2))
        // Position where the shape layer should be
        let shapePosition = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        let rippleShape = CAShapeLayer()
        rippleShape.bounds = CGRect(x: 0, y: 0, width: maxSizeBoundry, height: maxSizeBoundry)
        rippleShape.path = path.cgPath
        rippleShape.fillColor = effectColor!.cgColor
        //rippleShape.strokeColor = effectColor!.cgColor
        //rippleShape.lineWidth = 4
        rippleShape.position = shapePosition
        rippleShape.opacity = 0
        
        // Add the ripple layer as the sublayer of the reference view
        self.layer.addSublayer(rippleShape)
        // Create scale animation of the ripples
        let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        scaleAnim.toValue = NSValue(caTransform3D: CATransform3DMakeScale(2, 2, 1))
        // Create animation for opacity of the ripples
        let opacityAnim = CABasicAnimation(keyPath: "opacity")
        opacityAnim.fromValue = 1
        opacityAnim.toValue = nil
        // Group the opacity and scale animations
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnim, opacityAnim]
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.duration = CFTimeInterval(effectTime!)
        animation.repeatCount = 1
        animation.isRemovedOnCompletion = true
        rippleShape.add(animation, forKey: "rippleEffect")
        self.clipsToBounds = true
        DispatchQueue.main.asyncAfter(deadline: .now() + (effectTime! - 0.2)) {
            completion?()
        }
    }
    
}
