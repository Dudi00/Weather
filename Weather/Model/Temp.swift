//
//  Temp.swift
//  Weather
//
//  Created by Błażej Wdowikowski on 05/06/2016.
//  Copyright © 2016 blazej. All rights reserved.
//

import UIKit
import Decodable

struct Temp: Decodable {
    let day: Double // day temperature
    let min: Double // min daily temperature
    let max: Double // max daily temperature
    let night: Double //night temperature
    let eve: Double // evening temperature
    let morn: Double // morning temperature
    
    static func decode(json: AnyObject) throws -> Temp {
        return try Temp(
            day: json => "day",
            min: json => "min",
            max: json => "max",
            night: json => "night",
            eve: json => "eve",
            morn: json => "morn"
        )
    }
}

