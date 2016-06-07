//
//  Forecast.swift
//  WetherTest
//
//  Created by Błażej Wdowikowski on 05/06/2016.
//  Copyright © 2016 blazej. All rights reserved.
//

import UIKit
import Decodable

struct Forecast: Decodable {
    let dt: Int //date
    let temp: Temp // temperature
    let pressure: Double // pressure
    let humidity: Double // humidity
    let weathers: [Weather] // weather
    let speed: Double // spped of wind
    let deg: Int // degree
    let clouds: Double // cloudines
    
    var weather:Weather? {
        return weathers.first
    }
    
    static func decode(json: AnyObject) throws -> Forecast {
        return try Forecast(
            dt: json => "dt",
            temp: json => "temp",
            pressure: json => "pressure",
            humidity: json => "humidity",
            weathers: json => "weather",
            speed: json => "speed",
            deg: json => "deg",
            clouds: json => "clouds"
        )
    }
}
