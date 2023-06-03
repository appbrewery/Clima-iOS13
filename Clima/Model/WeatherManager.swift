
//
//  WeatherManager.swift
//  Clima
//
//  Created by reddy on 2023/5/14.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation
// Delegate Protocol
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    // Code Execution Flow :
    // `fetchWeather` => `performRequest` => `parseJSON` => `performRequest` => use delegate to execute `didUpdateWeather`
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=9fc56d9cea6967d9a5606f294e70e74d&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    // Methods can have same name as long as different parameter name
    // URL when user use search bar
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    // URL when automatic use phone GPS
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    
    // Networking Step-by-Step Guide
    func performRequest(with urlString: String) {
        // 1. Create a URL
        if let url = URL(string: urlString) { // String might have typo
            // 2. Create URL session
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                // Check Error
                if error != nil {  // If have error
                    self.delegate?.didFailWithError(error: error!)
                }
                // Fetch and Store Data
                if let safeData = data {
                    // Unwrap becuase `parseJSON` might be `nil`
                    if let weather = self.parseJSON(safeData) { // calling method from current struct so use `self`
                        // Apply Delegate Design Pattern
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            // 4. Start the task
            task.resume()
        }
    }
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
    // Here we decode the provided weatherData into an instance of the WeatherData type.
    // Takes an argument of type Data (JSON data file)
    // WeatherModel is optional because might have error returning `nil` in `catch`
        // Use JSON decoder
        let decoder = JSONDecoder()
        // `do` will execute `try`, and if succeed to decode then continues the rest, but if fail then will jump to `catch`
        do {
            // to use `decode` function, datatype must conform to `Decodable` protocol
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id // store decoded condition id
            let name = decodedData.name // store decoded city name
            let temp = decodedData.main.temp // store decoded temperature
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp) // Initialize WeatherModel from the data decoded above
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
   
}
