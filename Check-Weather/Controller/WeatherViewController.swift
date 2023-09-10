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
    
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var miniTempLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    var weatherForecastList:[WeatherItemModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchTextField.delegate = self // report back to viewController via delegate callbacks
        tableView.delegate = self
        tableView.dataSource = self
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
        fetchWeatherForecast(cityName)
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
                    AppUtils.Log(from: self, with: "weatherConditionSfIcon \(String(describing: weatherData?.locationWeather.weatherConditionSfIcon))")
                    if let iconName = weatherData?.locationWeather.weatherConditionSfIcon {
                        self.conditionImageView.image = UIImage(systemName:iconName)
                    }
                    cityLabel.text = weatherData?.locationName
                    currentTempLabel.text = weatherData?.locationWeather.weatherTempString
                    let miniTemp = weatherData?.locationWeather.weatherTempMin ?? 0.0
                    let highTemp = weatherData?.locationWeather.weatherTempMax ?? 0.0
                    miniTempLabel.text = WeatherUtils.formatTemperature(temperature: miniTemp)
                    highTempLabel.text = WeatherUtils.formatTemperature(temperature: highTemp)
                    let date = weatherData?.locationDate ?? 1694366698
                    dateLabel.text = AppUtils.formatDate(date)
                }
            }else {
                AppUtils.Log(from: self, with: "\(String(describing: message))")
            }
        }
    }
    
    
    func fetchWeatherForecast(_ cityName:String){
        let trimmed = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
        OpenWeatherApiClient.fetchWeatherForecast(cityName: trimmed) { [self] status, weatherDataList, message in
            if status {
                DispatchQueue.main.async { [self] in
                    if let list = weatherDataList {
                        weatherForecastList.removeAll()
                        weatherForecastList.append(contentsOf: list)
                        tableView.reloadData()
                    }
                }
            }else {
                AppUtils.Log(from: self, with: "\(String(describing: message))")
            }
        }
    }
}


// -------------------------------------------------------------------------
// MARK: Table View Data Source extention

extension WeatherViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherForecastList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherForecastCell", for: indexPath) as! WeatherForecastListCell
        let weatherData = self.weatherForecastList[(indexPath as NSIndexPath).row]
        
        cell.dateLabel.text = AppUtils.formatDate(weatherData.locationDate)
        
        // Set the name and image
        cell.weatherDescriptionLabel.text = weatherData.locationWeather.weatherCondition
        let iconName = weatherData.locationWeather.weatherConditionSfIcon
        cell.weatherConditionIcon.image = UIImage(systemName:iconName)
        cell.weatherTemp.text = weatherData.locationWeather.weatherTempString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shortRecipe = self.weatherForecastList[(indexPath as NSIndexPath).row]
        // performSegue(withIdentifier: kRecipeSegue, sender: shortRecipe)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

