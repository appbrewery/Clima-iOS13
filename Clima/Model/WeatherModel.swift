//
//  WeatherModel.swift
//  Clima
//
//  Created by Vincent Hunter on 2/16/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionID : Int
    let cityName : String
    let temperature : Double
    
    var temperatureString : String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName : String {
          switch conditionID {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return " cloud.drizzle"
        case 500...521 :
            return "cloud.rain"
        case 600...622 :
            return "cloud.snow"
        case 700...723:
            return "cloud.fog"
        case 800:
            return "sun.max"
        default:
           return "cloud"
        }
    }
    
    
}
