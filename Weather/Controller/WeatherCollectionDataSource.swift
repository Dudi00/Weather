//
//  WeatherCollectionDataSource.swift
//  Weather
//
//  Created by Błażej Wdowikowski on 06/06/2016.
//  Copyright © 2016 blazej. All rights reserved.
//

import UIKit
import AlamofireImage

protocol WeatherDataSource:UICollectionViewDataSource {
    func currentLocationName() -> String?
}

class WeatherCollectionDataSource: NSObject,WeatherDataSource {

    private var loadedForecasts:[Forecast]?
    private var cityName:String?
    lazy private var infoLabel:Label = {
        let label = Label();
        label.text = "Nie ma żadnej prognozy pogody, pociągnij w dół to może coś się pojawi"
        label.textColor = UIColor.grayColor()
        label.numberOfLines = 0
        label.textInset = UIEdgeInsetsMake(0, 20, 0, 20)
        label.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(14)
        return label
    }()
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        collectionView.backgroundView = nil
        if (loadedForecasts != nil && loadedForecasts!.count > 0) {
            return loadedForecasts!.count
        } else {
            collectionView.backgroundView = infoLabel
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ForecastViewCell.identifier, forIndexPath: indexPath) as! ForecastViewCell
        let forecast = loadedForecasts![indexPath.row]
        
        // Configure the cell
        configureForecastCell(cell, forecast: forecast)
        
        return cell
    }
    
    func refreshData(complete:((Bool)->Void)?){
        WeatherAPI.sharedClient.sevenDayForecastForPoznan { (response) in
            guard response.statusType != .ServerError else {
                    complete?(false)
                return
            }
            self.loadedForecasts = response.forecasts
            if let cityName = response.cityName {
                self.cityName = cityName
            }
            complete?(true)
        }
    }
    
    func currentLocationName() -> String? {
        return self.cityName
    }
    
    // MARK: Private methods
    
    private func decodeTime(dt:Double,format:String) -> String {
        let f = NSDateFormatter()
        f.dateFormat = format
        let date = NSDate(timeIntervalSince1970: dt)
        return f.stringFromDate(date)
    }
    
    private func configureForecastCell(cell:ForecastViewCell,forecast:Forecast) {
        cell.degreeLabel.text = NSString(format: "%0.0f°", forecast.temp.day) as String
        cell.minLabel.text = NSString(format: "%0.0f", forecast.temp.min) as String
        cell.minLabel.textColor = CommonColors.lightBlue
        cell.maxLabel.text = NSString(format: "%0.0f", forecast.temp.max) as String
        cell.maxLabel.textColor = CommonColors.deepdarkblue
        cell.pressureLabel.text = NSString(format: "%0.2f hPa", forecast.pressure) as String
        cell.dateLabel.text = decodeTime(Double(forecast.dt), format: "dd.MM")
        
        let imageView = cell.imgaView
        let url = NSURL(string: forecast.weather!.iconPath)!
        let placeholder = UIImage(named: "cloud")
        
        imageView.af_setImageWithURL(
            url,
            placeholderImage: placeholder,
            imageTransition: .CrossDissolve(0.5)
        )
    }
}
