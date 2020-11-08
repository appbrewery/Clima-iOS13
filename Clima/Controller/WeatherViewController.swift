//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

//API 06116b0878eabd7a6e0e7dbebdb89940

//Location GPS Steps
// import CoreLocation
// var locationManager = CLLocationManager()
// trigeer location Auth in ViewDIdload - locationManager.requestWhenInUseAuthorization()
// ****** learn how to use accuracy §§§§§§§ iOS 14+
//info.plist - add - Privacy - Location When In Use Usage Description - Run and Test
// request location -  locationManager.requestLocation()
//******* if using app where it requires constant mointoring / tracking - use locationManager.startMonitoring(for: <#T##CLRegion#>)  instead of  locationManager.requestLocation()

// add the CLLocationManagerDelegate protocol and delegate


import UIKit
import CoreLocation


protocol CLLocationManagerDelegate {
    
}

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    //initialize weather manager
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //text field should report back to view controller ..ie types return
        searchTextField.delegate = self
        weatherManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        //request location
        locationManager.requestLocation()
        
        
    }
    
    //MARK: Actions


    
}
// extension for UItextfield Delegate

//MARK: UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    
    @IBAction func searchBtnWasPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        
    }
    
    // return btn pressed via delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //dismiss keyboard
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    // textfield should editiing - Make sure the user entered text - Data Validation
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""  {
            return true
        } else {
            textField.placeholder = "Dont forget to type the words dork"
            return false
        }
    }

    
    // delegate method to clear search field after end editiing
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // use searchfield.text to get weather for that city
        if let city = searchTextField.text {
        weatherManager.fetchWeather(cityName: city)
//        print(city)
        }
        //clear textfield after typing
        searchTextField.text = ""
    }
    
    
}

// weather manager extension
//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    
    // Update Weather using delegate pattern - create protocol -
    func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: WeatherModel) {
//        print(weather.temperature)
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    //didfail with error
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

//MARK: - Location Manager

 
