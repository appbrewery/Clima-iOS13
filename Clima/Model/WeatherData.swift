//
//  WeatherData.swift
//  Clima
//
//  Created by Sal562 on 11/4/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

//https://api.openweathermap.org/data/2.5/find?appid=b687b8bdcf2dd6f944eb5e451446e887&units=metric&q=london

//MY Version
struct WeatherData: Codable {
    let list: [List]
    
    struct List: Codable {
        let name: String
        let main: Main
        let weather: [Weather]
        
        struct Main: Codable {
            let temp: Double
            let humidity: Int
        }
        
        struct Weather: Codable {
            let main: String
            let description: String
        }
    }
}






 


//// Angela Version
//struct WeatherData: Codable {
//    let name: String
//    let main: Main
//    let weather: [Weather]
//}
//
//struct Main: Codable {
//    let temp: Double
//}
//
//struct Weather: Codable {
//    let description: String
//    let id: Int
//}

// JSON BABY Version
//struct WWW: Codable {
//
//    let list: [Lists]
//
//    struct Lists: Codable {
//        let name: String
//        let main: Main
//        let weather: [Weather]
//
//        struct Main: Codable {
//            let temp: Double
//            let feelsLike: Double
//            let tempMin: Double
//            let tempMax: Double
//            let pressure: Int
//            let humidity: Int
//        }
//    }
//}
