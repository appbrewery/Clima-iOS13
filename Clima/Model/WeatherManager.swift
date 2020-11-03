//
//  WeatherManager.swift
//  Clima
//
//  Created by Sal562 on 11/3/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation


struct WeatherManger {
    let weatherURL = "http://api.openweathermap.org/data/2.5/find?appid=b687b8bdcf2dd6f944eb5e451446e887&units=metric"
    
    func fetchWeather(cityName: String) {
            let urlString = "\(weatherURL)&q=london"
    }
}
