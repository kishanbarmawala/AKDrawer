//
//  ResizingCVCell.swift
//  AKDrawer
//
//  Created by Kishan Barmawala on 30/11/19.
//  Copyright © 2019 Gatisofttech. All rights reserved.
//

import UIKit

class ResizingCVCell: UICollectionViewCell {

    lazy var width : NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width , height: 1))
    }
}
