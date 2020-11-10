//
//  WeatherManager.swift
//  Clima
//
//  Created by Krupali Patel on 11/9/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager{
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=1c62c8c24eec3960c582f05646bdc1fa"
    
    func fetchWeatherURL(cityName: String){
        let url = "\(weatherURL)&q=\(cityName)"
        print(url)
    }
}
