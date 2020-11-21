//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherInstance = WeatherManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherInstance.delegate = self
        searchTextField.delegate = self
    }
    
    @IBAction func searchClicked(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text ?? "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        print(textField.text ?? "")
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if(textField.text != ""){
            return true
        }
        textField.placeholder = "enter value"
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Fetch value of entered text
        //Fetch weather of the city
        if let cityName = textField.text {
            weatherInstance.fetchWeatherURL(cityName: cityName)
        }
        textField.placeholder = "Search"
        textField.text = ""
    }
}

extension WeatherViewController: WeatherManagerDelegate{
    func didUpdateWeather(weather: WeatherModel) {
        print(weather)
        print(weather.conditionName)
        
    }
    
}
