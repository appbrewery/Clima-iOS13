//
//  WeatherManager.swift
//  Clima
//
//  Created by Cihan Bayoğlu on 15.11.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager,_ weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=YOUR_API_KEY&units=metric&"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName : String) {
        let urlString = "\(weatherURL)q=\(cityName)"
        performRequest(with:  urlString)
    }
    
    func fetcWeather(latitude: Double , longitude: Double) {
        let urlString = "\(weatherURL)lat:\(latitude)&lon:\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // 1. Create a URL
        if let url = URL(string: urlString) {
            // 2. Create a URLSesssion
            let session = URLSession(configuration: .default)
            // 3. Give the session task
            // func f(){ }  =  func f() -> void { }
            let task = session.dataTask(with: url) { data, response, error  in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    // eğer hata alırsan fonksiyonu durdur.
                    return
                }
                
                if let safeData = data {
                    //*Kural* Closure içinde, mevcut sınıftan bir yöntem çağırıyorsak "self" keyword ünü. eklememiz gerekir.
                    if let weather = parseJSON( safeData){
                        
                        delegate?.didUpdateWeather(self, weather)
                    }
                }
            }
            // 4. Start the task
            task.resume()
        }
    }
    //    // dataTask() metodu tetiklendiğinde ilgili url den aldıklarını handle içerisine yerleştirir.
    //    func handle(data: Data?, response: URLResponse?, error: Error?) {
    //
    //        if error != nil {
    //            print(error!)
    //            // eğer hata alırsan fonksiyonu durdur.
    //            return
    //        }
    //
    //        if let safeData = data {
    //
    //            let dataString = String(data: safeData, encoding: .utf8)
    //            print(dataString)
    //        }
    //    }
    
    
    func parseJSON(_ weatherData : Data) -> WeatherModel? {
        
        let decoder = JSONDecoder()
        
        // decode() input olarak bir obje yerine bir type istediği için objemizin sonuna ".self" ekliyoruz.
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionId: id, cityName: name, temp: temp)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
