//
//  ForecastViewCell.swift
//  Weather
//
//  Created by Błażej Wdowikowski on 06/06/2016.
//  Copyright © 2016 blazej. All rights reserved.
//

import UIKit

class ForecastViewCell: UICollectionViewCell {
    static let identifier:String = "forecastCell"
    static var defaultSize:CGSize {
        return CGSizeMake(104, 128)
    }
    
    @IBOutlet weak var imgaView: UIImageView!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
