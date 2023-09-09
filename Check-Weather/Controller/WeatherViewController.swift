//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchTextField.delegate = self // report back to viewController via delegate callbacks
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let cityName = searchTextField.text else {
            searchTextField.placeholder = "Please type location"
            return
        }
        print(cityName)
        searchTextField.text = ""
        let trimmed = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
        OpenWeatherApiClient.fetchWeather(cityName: trimmed)
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else {
            searchTextField.placeholder = "Please type location"
            return false
        }
    }
    
}

