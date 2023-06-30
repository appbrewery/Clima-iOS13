//
//  WeatherData.swift
//  Clima
//
//  Created by Ramon Seoane Martin on 13/4/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
	let name: String
	let main: Main
	let weather: [Weather]
}


struct Main: Decodable {
	let temp: Double
}

struct Weather: Decodable {
	let id: Int
	let description: String
}
