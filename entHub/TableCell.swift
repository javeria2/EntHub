//
//  TableCell.swift
//  entHub
//
//  Created by Sanchay  Javeria on 6/30/16.
//  Copyright © 2016 SanchayJaveria. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {

    @IBOutlet weak var dp: UIImageView!
    @IBOutlet weak var mainImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func drawRect(rect: CGRect) {
        dp.layer.cornerRadius = dp.frame.size.width / 2
        dp.clipsToBounds = true
        mainImage.clipsToBounds = true
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
