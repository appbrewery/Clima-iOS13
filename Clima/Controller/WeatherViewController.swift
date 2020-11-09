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
// info.plist - add - Privacy - Location When In Use Usage Description - Run and Test
//set delegate before requesting location
// Assign delegate   locationManager.delegate = self

// desiredAccuracy of location locationManager.desiredAccuracy = kCLLocationAccuracyBest

// request location -  locationManager.requestLocation()
//******* if using app where it requires constant mointoring / tracking - use locationManager.startMonitoring(for: <#T##CLRegion#>)  instead of  locationManager.requestLocation()


// add the CLLocationManagerDelegate protocol and delegate methods (2)
// didUpdateLocations & didFailWithError - Use Print inside function to check output of location
//   inside didUpdateLocations - print("You are here: \(locationManager.location?.coordinate.latitude) + \(locationManager.location?.coordinate.longitude)")
//print(locationManager.location) OR UNWRAP LOCATION LONG/LAT
//if let location = locations.last {
//    let long = location.coordinate.longitude
//    let lat = location.coordinate.latitude
//
//    print("Final Unwrapped Longitude: \(long) & \(lat)")
//}


import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
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
        
        //set delegate before requesting location
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        //Requests the one-time delivery of the user’s current location.
        locationManager.requestLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    //MARK: Actions
    
    //location button
    @IBAction func locationBtnWasPressed(_ sender: UIButton) {
        
        locationManager.requestLocation()
        
    }
    

    
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

//MARK: - CLLocation Manager Delegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //needed
        print("You are here: \(locationManager.location?.coordinate.latitude) + \(locationManager.location?.coordinate.longitude)")
        print(locationManager.location)
        
        if let location = locations.last {
            let long = location.coordinate.longitude
            let lat = location.coordinate.latitude
            
//            print("Final Unwrapped Longitude: \(long) & \(lat)")
            weatherManager.fetchWeather(latitude: lat, longitude: long)
        }
    }
    
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//
//    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("unable to get location: \(error)")
    }
    
    
}
