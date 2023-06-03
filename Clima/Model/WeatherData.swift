//
//  WeatherData.swift
//  Clima
//
//  Created by reddy on 2023/5/18.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

// Data retrieved from API is in JSON format
// Decodable Protocol : used for decoding (parsing) data from external representations, such as JSON or property lists, into native Swift objects.
struct WeatherData: Codable {
    let name: String
    let main: WeatherDataMain
    let weather: [WeatherDataWeather] // Can hold an array of `WeatherDataWeather` objects
}

// `main` struct from JSON data
// MUST have the same name for variables as the JSON
struct WeatherDataMain: Codable {
    let temp: Double
    
}

struct WeatherDataWeather: Codable {
    let id: Int
}
