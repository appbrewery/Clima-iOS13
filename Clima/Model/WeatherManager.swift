//
//  WeatherManager.swift
//  Clima
//
//  Created by Sal562 on 11/3/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit

//Networking Steps
//1 Create URL
//2 CreateURLSession
//3 Give the session a Task
//4 Start the task

struct WeatherManger {
    let weatherURL = "https://api.openweathermap.org/data/2.5/find?appid=b687b8bdcf2dd6f944eb5e451446e887&units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    //perform request     //Networking Steps
    
    func performRequest(urlString: String) {
        
        //1 Create URL
        if let url = URL(string: urlString) {
            //2 CreateURLSession
            let session = URLSession(configuration: .default)
            
            //3 Give the session a Task ==OLD METHOD
            // let task = session.dataTask(with: url, completionHandler: handle(data:response:error: ))
            
            //3.5 - IMPROVED Using Closure
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
//                    let dataString = String(data: safeData, encoding: .utf8)
//                    print(safeData)
                    
                    //DONT PRINT. Parse Jason DATA to be readable
                    parseJSON(weatherData: safeData)
                    
                }
            }
            
            //4 Start the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
//            print(decodedData.list[0].name)
//            print(decodedData.list[0].main.temp)
//            print(decodedData.list[0].weather.description)
//            print(decodedData.list[0].weather[0].id)
            
            let id = decodedData.list[0].weather[0].id
            let temp = decodedData.list[0].main.temp
            let name = decodedData.list[0].name

            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp)
//            print(weather.getConditionName(weatherID: id)) -- Use COmputed Property below
            print(weather.conditionName)
            print(weather.temperatureString)
            
        } catch {
            print(error)
        }
    }
    
}
