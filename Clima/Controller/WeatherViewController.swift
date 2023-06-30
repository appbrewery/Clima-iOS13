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
	

	//MARK: - Outlets
	
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
	@IBOutlet weak var searchTextField: UITextField!
	
	//MARK: - Vars
	
	var weatherManager = WeatherManager()
	let locationManager = CLLocationManager()
	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		// Set the VC as delegate of the WeatherManager !!!
		weatherManager.delegate = self
		searchTextField.delegate = self
		locationManager.delegate = self
		
		// Set the API Key to the WeatherManager
		let keys = appDelegate.keys!
		weatherManager.apiKey = keys["apiKey"] as! String
		
		locationManager.requestWhenInUseAuthorization()
		locationManager.requestLocation()
		
		setupUI()
    }
	
	//MARK: - Private functions
	
	private func setupUI() {
		// set up the user inteface
	}
	
	@IBAction func locationButtonPressed(_ sender: UIButton) {
		locationManager.requestLocation()
	}
	
}


//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
	
	@IBAction func searchPressed(_ sender: UIButton) {
		print(searchTextField.text ?? "\n\n")
		searchTextField.endEditing(true)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		print(searchTextField.text ?? "\n\n")
		searchTextField.endEditing(true)
		return true
	}
	
	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		if textField.text != "" {
			return true
		} else {
			textField.placeholder = "Type something here"
			return false
		}
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		
		// Use the searchTextField.text to get the weather for that city.
		if let city = searchTextField.text {
			
			weatherManager.fetchWeather(cityName: city)
		}
		
		searchTextField.text = ""
	}
	
}


//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
	
	func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
		print(weather.temperature)
		DispatchQueue.main.async {
			self.temperatureLabel.text = weather.temperatureString
			self.conditionImageView.image = UIImage(systemName: weather.conditionName)
			self.cityLabel.text = weather.cityName + " - \(weather.description)"
		}
	}
	
	func didFailWithError(error: Error) {
		
		// Any error handling required
		print(error)
	}
}


//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		
		if let location = locations.last {
			// Dejamos de pillar ubicación para que no esté en segundo plano en bucle
			locationManager.stopUpdatingLocation()
			
			let lat = location.coordinate.latitude
			let lon = location.coordinate.longitude
			
			print("location:: \(location.description)")
			
			weatherManager.fetchWeather(latitude: lat, longitude: lon)
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		
		print(error)
	}
}
