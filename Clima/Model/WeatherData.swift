//
//  WeatherData.swift
//  Clima
//
//  Created by Sal562 on 11/4/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let list: [List]
//    let main: Main
}

struct List: Codable {
    let name: String
}

//struct Main: Decodable {
//    let temp: Double
//}
