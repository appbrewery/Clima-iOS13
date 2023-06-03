//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet var searchTextField: UITextField!
    
    // Model
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager() // Get hold of GPS on the phone
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Delegates
        searchTextField.delegate = self // Set as delegate to handler `UITextField`
        weatherManager.delegate = self // Set as delegate to handler `WeatherManager`
        locationManager.delegate = self // Set as delegate to handler `locationManager.requestLocation`
        
        // Request user for location
        locationManager.requestWhenInUseAuthorization()
        // One-time delivery location
        locationManager.requestLocation() // immediately calls `didUpdateLocations` method
    }
    
    @IBAction func currentLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}

//MARK: - LocationManagerDelegate

// Extension: LocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation() // Once we find location tell locationManager to stop updating location, so when we press currentLocation button, we can once again trigger location service `didUpdateLocations` or else it will not run again
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            // Execute `fetchWeather` which leads to `didUpdateWeather`
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
     
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


//MARK: - UITextFieldDelegate

// Extension: UITextField Usages
extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) { // Press Search icon
        searchTextField.endEditing(true)
    }
    
    // When the user taps the Return key while editing a text field, the system calls this method to determine whether to end editing of the text field or not.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // Press Return button
        searchTextField.endEditing(true)
        return true // The return value of textFieldShouldReturn is a boolean value indicating whether the text field should resign first responder status to end editing or not.
    }
    
    // When user tap somewhere else to try to exit keyboard
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" { // User should input String
            return true // whether the text field should resign first responder status and end editing
        } else {
            textField.placeholder = "Type location"
            return false
        }
    }
    
    // When the user finish editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Use text to execute fetchWeather
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = "" // Clear textField when done editing
    }
}

//MARK: - WeatherManagerDelegate

// Extension: WeatherManagerDelegate to update UI
extension WeatherViewController: WeatherManagerDelegate {
    // Update Weather to UI
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        // Networking happens in the background, so the modify of the UI also need to happen in the background
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString // Update temperature
            // Closure so need `self.`
            self.conditionImageView.image = UIImage(systemName: weather.conditionName) // Update condition image
            self.cityLabel.text = weather.cityName // Update City Name
        }
    }
    // If fail to update weather
    func didFailWithError(error: Error) {
        print(error)
    }
}
