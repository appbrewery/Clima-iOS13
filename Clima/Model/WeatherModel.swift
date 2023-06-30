//
//  WeatherModel.swift
//  Clima
//
//  Created by Ramon Seoane Martin on 14/4/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
	
	let conditionId: Int
	let cityName: String
	let temperature: Double
	let description: String

	var temperatureString: String {
		return String(format: "%.1f", temperature)
	}
	
	var conditionName: String {
		switch conditionId {
		case 200...232:
			return "cloud.bolt"
		case 300...321:
			return "cloud.drizzle"
		case 500...531:
			return "cloud.rain"
		case 600...622:
			return "cloud.snow"
		case 701...781:
			return "cloud.fog"
		case 800:
			return "sun.max"
		case 801...804:
			return "cloud"
		default:
			return "cloud"
		}
	}
}
