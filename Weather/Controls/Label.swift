//
//  Label.swift
//  czyPojade
//
//  Created by Błażej Wdowikowski on 28/05/2016.
//  Copyright © 2016 dudi. All rights reserved.
//

import UIKit

class Label: UILabel {
    var textInset:UIEdgeInsets?
    
    override func drawTextInRect(rect: CGRect) {
        guard let inset = textInset else {
            super.drawTextInRect(rect)
            return
        }
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, inset))
    }
}
