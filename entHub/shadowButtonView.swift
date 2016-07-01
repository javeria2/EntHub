//
//  shadowButtonView.swift
//  entHub
//
//  Created by Sanchay  Javeria on 6/29/16.
//  Copyright © 2016 SanchayJaveria. All rights reserved.
//

import UIKit

class shadowButtonView: UIButton {

    override func awakeFromNib() {
        layer.cornerRadius = 5.0
        layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 0.5).CGColor
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSizeMake(0, 2)
    }

}
