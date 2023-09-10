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
        makeApiCall(cityName)
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else {
            searchTextField.placeholder = "Please type location"
            return false
        }
    }
    
    
    func makeApiCall(_ cityName:String){
        let trimmed = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
        OpenWeatherApiClient.fetchDayWeather(cityName: trimmed) { [self] status, weatherData, message in
            if status {
                DispatchQueue.main.async { [self] in
                    temperatureLabel.text = weatherData?.locationWeather.weatherTempString
                    AppUtils.Log(from: self, with: "weatherConditionSfIcon \(weatherData?.locationWeather.weatherConditionSfIcon)")
                    if let iconName = weatherData?.locationWeather.weatherConditionSfIcon {
                        self.conditionImageView.image = UIImage(systemName:iconName)
                    }
                    cityLabel.text = weatherData?.locationName
                }
            }else {
                AppUtils.Log(from: self, with: "\(String(describing: message))")
            }
        }
    }
    
}

