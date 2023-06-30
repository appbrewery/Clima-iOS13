//
//  WeatherManager.swift
//  Clima
//
//  Created by Ramon Seoane Martin on 8/4/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
	func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
	func didFailWithError(error: Error)
}

struct WeatherManager {
	
	var apiKey = "" // We'll retrieve it from a Keys.plist storign our API Key
	
	let weatherURL = "https://api.openweathermap.org/data/2.5/weather?lang=es&units=metric"
	
	var delegate: WeatherManagerDelegate?
	
	func fetchWeather(cityName: String) {
		let urlString = "\(weatherURL)&q=\(cityName)&appid=\(apiKey)"
		
		print(urlString)
		performRequest(with: urlString)
	}
	
	func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
		let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
		
		print(urlString)
		performRequest(with: urlString)
	}
	
	
	func performRequest(with urlString: String) {
		// 1. Create a URL
		if let url = URL(string: urlString) {
			
			// 2. Create a URLSession
			let session = URLSession(configuration: .default)
			
			// 3. Give the session a task
			let task = session.dataTask(with: url) { (data, response, error) in
				if error != nil {
					delegate?.didFailWithError(error: error!)
					return
				}
				
				if let safeData = data {
					if let weather = parseJSON(safeData) {
						delegate?.didUpdateWeather(self, weather: weather)
					}
				}
			}
			// 4. Start the task
			task.resume()
		}
	}
	
	func parseJSON(_ weatherData: Data) -> WeatherModel? {
		let decoder = JSONDecoder()
		do{
			let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
			
			let id = decodedData.weather[0].id
			let temp = decodedData.main.temp
			let name = decodedData.name
			let description = decodedData.weather[0].description
			
			let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, description: description)
		
//			print(weather.conditionName)
//			print(weather.temperatureString)
			return weather
			
		} catch {
			delegate?.didFailWithError(error: error)
			return nil
		}
	}
	
	
	
}
