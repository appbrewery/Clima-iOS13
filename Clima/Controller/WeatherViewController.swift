//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
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
    
    
}
extension WeatherViewController : UITextFieldDelegate{
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
            weatherInstance.fetchWeatherURL(cityName)
        }
        textField.placeholder = "Search"
        textField.text = ""
    }
}

extension WeatherViewController: WeatherManagerDelegate{
    func didFailWithError(_ error: Error) {
        print(error)
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        print(weather)
        print(weather.conditionName)
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
}
