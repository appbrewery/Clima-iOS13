//
//  WeatherData.swift
//  Clima
//
//  Created by Krupali Patel on 11/10/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData : Decodable{
    let name: String
    let main: mainStruct
    let weather : [weatherStruct]
}

struct mainStruct : Decodable{
    let temp: Double
}

struct weatherStruct : Decodable{
    let description : String
    let id : Int
    
}
