//
//  WeatherManager.swift
//  Clima
//
//  Created by Sal562 on 11/3/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager,_ weather: WeatherModel)
    func didFailWithError(error: Error)
}

//Networking Steps
//1 Create URL
//2 CreateURLSession
//3 Give the session a Task
//4 Start the task

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/find?appid=b687b8bdcf2dd6f944eb5e451446e887&units=metric"
    
    //weather URL with lon & lat
    // https://api.openweathermap.org/data/2.5/find?appid=b687b8bdcf2dd6f944eb5e451446e887&units=metric&lat=51&lon=-0.1
    
    //delegate for weather manager
    var delegate: WeatherManagerDelegate?
    
    
    //func fetchWeatherLocation
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
        
    }
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    //perform request     //Networking Steps
    
    func performRequest(with urlString: String) {
        
        //1 Create URL
        if let url = URL(string: urlString) {
            //2 CreateURLSession
            let session = URLSession(configuration: .default)
            
            //3 Give the session a Task ==OLD METHOD
            // let task = session.dataTask(with: url, completionHandler: handle(data:response:error: ))
            
            //3.5 - IMPROVED Using Closure
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
//                    let dataString = String(data: safeData, encoding: .utf8)
//                    print(safeData)
                    
                    //DONT PRINT. Parse Jason DATA to be readable
                    
                    if let weather = self.parseJSON(safeData) {
                    delegate?.didUpdateWeather(self, weather)
                    }
                    
                }
            }
            
            //4 Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
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
            return weather
            
        } catch {
//            print(error)
            // use delegate to pass errors
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
