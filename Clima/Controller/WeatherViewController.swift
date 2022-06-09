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
    
    
    @IBOutlet var txtFieldSearch: UITextField!
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet var locationButton: UIButton!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()

    
    
    override func viewDidLoad() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        super.viewDidLoad()
        txtFieldSearch.delegate = self
        weatherManager.delegate = self
        
        
        
    }

    
    @IBAction func getLocationBtn(_ sender: UIButton) {
        locationManager.requestLocation()
        
        
    
   }
}
    
//MARK: - > Add a completion
// Add the name of the section
    
    
    
    extension WeatherViewController : UITextFieldDelegate {
        @IBAction func searchPressed(_ sender: Any) {
            txtFieldSearch.endEditing(true)
            print(txtFieldSearch.text!)
        }
        // Lets app process the return button when pressed by user
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            txtFieldSearch.endEditing(true)
            
            print(txtFieldSearch.text!)
            return true
        }
        
        //Prevents the user from entering textfield with no text
        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            if txtFieldSearch.text != ""{
                return true
            } else {
                txtFieldSearch.placeholder = "Type something here"
                return false
            }
        }
        
        // Allows text field to clear once the return/search button is pressed
        func textFieldDidEndEditing(_ textField: UITextField) {
            
            // Use textFieldSearch.text to Get the weather for the city
            if let city = txtFieldSearch.text{
                weatherManager.retrieveWeather(cityName: city)
            }
            //Empties the textfield after the user presses button
            txtFieldSearch.text = ""
        }
        
    }

//MARK: - Weather Manager Extension
    
    extension WeatherViewController: WeatherManagerDelegate {
        
        //Method that updates the UI tools with the weather conditions of desired location
        func didUpdateWeather(_ weatherManager : WeatherManager, weather : WeatherModel){
            DispatchQueue.main.async {
                self.temperatureLabel.text = weather.temperatureString
                self.conditionImageView.image = UIImage(systemName: weather.conditionName)
                self.cityLabel.text = weather.cityName
            }
            
            
        }
        
        func didFailWithError(error: Error) {
            print(error)
        }
        
    }

// MARK: - CLLocationManagerDelegate
extension WeatherViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.retrieveWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location \(error.localizedDescription)")
            
        }
    }
        


