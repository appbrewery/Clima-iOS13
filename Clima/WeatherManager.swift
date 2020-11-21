//
//  WeatherManager.swift
//  Clima
//
//  Created by Krupali Patel on 11/9/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(_ error: Error)
}
struct WeatherManager{
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=1c62c8c24eec3960c582f05646bdc1fa&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeatherURL(_ cityName: String){
        let url = "\(weatherURL)&q=\(cityName)"
        performRequest(url)
        print(url)
    }
    
    func performRequest(_ urlString: String){
        //1. Create a URL
        if let url = URL(string: urlString){
            //2. Create a Session
            let session = URLSession(configuration: .default)
            
            //3. Give Session a Task
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error{
                    self.delegate?.didFailWithError(error)
                    return
                }
                if let safeData = data {
                    if let weather = parseWeatherData(safeData){
                        //delegate data to viewController
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //4. Start Task
            task.resume()
        }
    }
    
    func parseWeatherData(_ weatherData: Data) -> WeatherModel?{
        let jsonDecoder = JSONDecoder()
        do{
            let decodedData = try jsonDecoder.decode(WeatherData.self, from: weatherData)
            let temp = decodedData.main.temp
            let weatherId = decodedData.weather[0].id
            let cityName = decodedData.name
        
            let weather = WeatherModel(conditionId: weatherId, cityName: cityName, temperature: temp)
            return weather
        }catch{
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
}
