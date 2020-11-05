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
            getConditionName(weatherID: id)
            
            
        } catch {
            print(error)
        }
    }
    
    
    // get weather ID switch
    func getConditionName(weatherID: Int) -> String {
        
        let thunderstorm = UIImage(systemName: "cloud.bolt", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))
        let drizzle = UIImage(systemName: "cloud.drizzle", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))
        let rain = UIImage(systemName: "cloud.heavyrain", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))
        let snow = UIImage(systemName: "snow", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))
        let atmosphere = UIImage(systemName: "smoke", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))
        let clear = UIImage(systemName: "cloud", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))
        let clouds = UIImage(systemName: "cloud.fog", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))
    
        switch weatherID {
        case 200...240:
            return thunderstorm
        case 300...350:
            return drizzle
        case 500...550:
            return rain
        case 600...630:
            return snow
        case 700...782:
            return atmosphere
        case 800:
            return clear
        case 801...805:
            return clouds
        default:
            return clear
        }
        
    }
    
}
