//
//  WeatherModel.swift
//  Clima
//
//  Created by Sal562 on 11/5/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit

struct WeatherModel {
    
    //Stored Property
    let conditionID: Int
    let cityName: String
    let temperature: Double
    
    
    //computed Property
    
    var conditionName: String {
        switch conditionID {
        case 200...240:
            return "cloud.bolt"
        case 300...350:
            return "cloud.drizzle"
        case 500...550:
            return "cloud.rain"
        case 600...630:
            return "cloud.snow"
        case 700...782:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...805:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
    // get weather ID switch - DONT USE if Using computed Property
//    func getConditionName(weatherID: Int) -> String {
//    }

    
}
