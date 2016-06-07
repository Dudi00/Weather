//
//  Weather.swift
//  Weather
//
//  Created by Błażej Wdowikowski on 05/06/2016.
//  Copyright © 2016 blazej. All rights reserved.
//

import UIKit
import Decodable

struct Weather: Decodable {
    let id:Int // weather condition id
    let main: String // group of weather
    let weatherDescription: String //weather condition with group
    let icon: String // weather icon
    
    var iconPath:String {
        return "http://openweathermap.org/img/w/\(icon).png"
    }
    
    static func decode(json: AnyObject) throws -> Weather {
        return try Weather(
            id: json => "id",
            main: json => "main",
            weatherDescription: json => "description",
            icon: json => "icon"
        )
    }
}
