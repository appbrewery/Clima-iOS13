//
//  WeatherData.swift
//  Clima
//
//  Created by Cihan Bayoğlu on 16.11.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name : String
    let id : Int
    let weather : [Weather]
    let main : Main
}

struct Weather : Codable {
    let id : Int
}

struct Main : Codable {
    let temp : Double
}
