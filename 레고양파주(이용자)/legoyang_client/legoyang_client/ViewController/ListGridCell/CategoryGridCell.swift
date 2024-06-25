//
//  CategoryGridCell.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/05/11.
//

import UIKit

class CategoryGridCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabelWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIViewController.CategoryGridCellDelegate = self
    }
}
