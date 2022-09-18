//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var txtFieldSearch: UITextField!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFieldSearch.delegate = self
    }

    @IBAction func btnSearchAction(_ sender: UIButton) {
        weatherManager.fetchWeather(cityname: txtFieldSearch.text!)
        txtFieldSearch.endEditing(true)
    }
    
}

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        weatherManager.fetchWeather(cityname: textField.text!)
        txtFieldSearch.endEditing(true)
        return true
    }
}

