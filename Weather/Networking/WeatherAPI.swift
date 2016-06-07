//
//  WetherAPI.swift
//  WetherTest
//
//  Created by Błażej Wdowikowski on 05/06/2016.
//  Copyright © 2016 blazej. All rights reserved.
//

import UIKit
import Alamofire
import Decodable


enum ApiResultType {
    case Success
    case ServerError
    case NetworkUnreachable
}

struct WeatherResponse:Decodable {
    let statusType:ApiResultType
    let cityName:String?
    let forecasts:[Forecast]?
    
    init(cityName:String,days:[Forecast]){
        self.statusType = .Success
        self.cityName = cityName
        self.forecasts = days
    }
    
    init(statusType:ApiResultType,cityName:String?,days:[Forecast]?){
        self.statusType = statusType
        self.cityName = cityName
        self.forecasts = days
    }
    
    static func serverError() -> WeatherResponse{
        return WeatherResponse(statusType: .ServerError,cityName: nil,days: nil)
    }
    
    static func decode(j: AnyObject) throws -> WeatherResponse {
        return try WeatherResponse(
            cityName: j => "city" => "name",
            days: j => "list"
        )
    }
}

class WeatherAPI: NSObject {
    
    lazy private var manager : Alamofire.Manager = {
        return Manager(serverTrustPolicyManager: ServerTrustPolicyManager(policies: ["api.openweathermap.org":.DisableEvaluation]))
    }()
    private static let baseURL = "http://api.openweathermap.org/data/2.5/forecast/daily?"
    static var apiKey:String?
    static let sharedClient:WeatherAPI = WeatherAPI()
    
    enum City:String {
        case Poznan = "7530858"
    }
    
    enum Units:String{
        //Default is Kelvin
        case Metric = "Metric"
        case Imperial = "Imperial"
        case Kelvin = ""
    }

    enum Lang:String{
        case PL = "pl"
        case EN = "en"
    }

    enum Model:String{
        case JSON = "json"
        case XML = "xml"
    }
    
    // MARK: Public Methods
    
    /**
     method will return forecast for poznan for next 7 days
     */
    func sevenDayForecastForPoznan(complete:((WeatherResponse)->Void)?) {
        let cityId:City = .Poznan
        let days:Int = 7
        let unit:Units = .Metric
        let lang:Lang = .PL
        let model:Model = .JSON
        
        forecastForCity(cityId, days: days, units: unit, lang: lang, model: model){ response in
            complete?(response)
        }
    }
    
    /**
     Universal method to get forecast
     
     - parameter cityId: list of cites is avalible at http://bulk.openweathermap.org/sample/
     - parameter days:   number of days for forecast (1-16)
     - parameter units:  type of temp. units. Imperial or Celcius. Kelvin is default value
     - parameter lang:   language for wether description
     - parameter model:  model of data that will be returned
     */
    func forecastForCity(cityId:City,days:Int,units:Units,lang:Lang,model:Model,complete:((WeatherResponse)->Void)?){
        guard let apiKey = WeatherAPI.apiKey else {
            print("ApiKey is not provided")
            return
        }
        
        var url = WeatherAPI.baseURL
        url += "id=\(cityId.rawValue)&cnt=\(days)&units=\(units.rawValue)&model=\(model.rawValue)&lang=\(lang.rawValue)&appid=\(apiKey)"
        
        manager.request(.GET, url).responseJSON { response in
            guard response.result.isSuccess,
                let json = response.result.value else {
                    print("API ERROR: \(response.result.error?.localizedDescription)")
                    complete?(WeatherResponse.serverError())
                    return
            }
            do {
                let response =  try WeatherResponse.decode(json)
                complete?(response)
            } catch let error {
                print("Error with mapping json: \(error)")
                complete?(WeatherResponse.serverError())
            }
            return
        }
    }
    
    // MARK: Private methods
    
}
  