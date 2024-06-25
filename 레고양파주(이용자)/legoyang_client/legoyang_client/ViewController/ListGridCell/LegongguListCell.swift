//
//  LegongguListCell.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/05/03.
//

import UIKit

class LegongguListCell: UITableViewCell {
    
    var timer: Timer? = nil
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemCloseTimeLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemPriceLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var itemCountLabel: UILabel!
    @IBOutlet weak var itemCountLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemBasePriceLabel: UILabel!
    @IBOutlet weak var itemDiscountPercentLabel: UILabel!
    @IBOutlet weak var itemDiscountPriceLabel: UILabel!
    @IBOutlet weak var itemBuyCountLabel: UILabel!
}
