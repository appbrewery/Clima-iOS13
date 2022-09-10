//
//  Weathermanager.swift
//  Clima
//
//  Created by Bhishak Sanyal on 10/09/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=f52de806f4ee5a499a3b8081decb1780"
    
    func fetchWether(cityname: String) {
        let urlString = "\(weatherURL)&q=\(cityname)"
        makeReqest(urlString: urlString)
    }
    
    private func makeReqest(urlString: String) {
        if let url = urlString.getCleanedURL() {
            let session = URLSession.init(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                }
                
                if let safedata = data {
                    parseData(data: safedata)
                }
            }
            
            task.resume()
        }
    }
    
    private func parseData(data: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            print(decodedData.name)
            print(decodedData.main.temp)
            print(decodedData.weather[0].main)
        } catch {
            print(error)
        }
        
    }
}

extension String {
 func getCleanedURL() -> URL? {
    guard self.isEmpty == false else {
        return nil
    }
    if let url = URL(string: self) {
        return url
    } else {
        if let urlEscapedString = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) , let escapedURL = URL(string: urlEscapedString){
            return escapedURL
        }
    }
    return nil
 }
}
