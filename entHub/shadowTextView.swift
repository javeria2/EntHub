//
//  shadowTextView.swift
//  entHub
//
//  Created by Sanchay  Javeria on 6/29/16.
//  Copyright © 2016 SanchayJaveria. All rights reserved.
//

import UIKit

class shadowTextView: UITextField {

    override func awakeFromNib() {
        layer.cornerRadius = 5.0
    }
    
    /* to move the placeholder text inside the textField */
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 7, 0)
    }
    
    /* for when user is actually typing in the textField */
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 7, 0)
    }

}
