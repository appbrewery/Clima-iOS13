//
//  WeatherManager.swift
//  Clima
//
//  Created by Krupali Patel on 11/9/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager{
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=1c62c8c24eec3960c582f05646bdc1fa&units=metric"
    
    func fetchWeatherURL(cityName: String){
        let url = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: url)
        print(url)
    }
    
    func performRequest(urlString: String){
        //1. Create a URL
        if let url = URL(string: urlString){
            //2. Create a Session
            let session = URLSession(configuration: .default)
            
            //3. Give Session a Task
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error{
                    print(error)
                    return
                }
                if let safeData = data {
                    parseWeatherData(weatherData: safeData)
                }
            }
            //4. Start Task
            task.resume()
        }
    }
    
    func parseWeatherData(weatherData: Data){
        let jsonDecoder = JSONDecoder()
        do{
            let decodedData = try jsonDecoder.decode(WeatherData.self, from: weatherData)
            print(decodedData.main.temp)
            print(decodedData.weather[0].description)
        }catch{
            print(error)
        }
        
    }
}
