//
//  ViewController.swift
//  Clima
//
//  Created by Awesome Jimon 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
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
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchTextField.delegate = self // report back to viewController via delegate callbacks
        tableView.delegate = self
        tableView.dataSource = self
        
        locationManager.delegate = self
        
        // Request for Location Permiti
        locationManager.requestWhenInUseAuthorization()
        
        //request for a 1 time location
        locationManager.requestLocation()
        
        
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        
    }
    
    @IBAction func LocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    //-----------------------------------------------------------------
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetails" {
            let detailVC = segue.destination as! DetailsViewController
            detailVC.dataModel = sender as? WeatherItemModel
        }
    }
    
    //
    func makeApiCall(_ cityName:String){
        let trimmed = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
        OpenWeatherApiClient.fetchDayWeather(cityName: trimmed) { [self] status, weatherData, message in
            if status {
                DispatchQueue.main.async { [self] in
                    if let currentWeatherData = weatherData {
                        updateLocationDetails(weatherData: currentWeatherData)
                    }
                }
            }else {
                AppUtils.Log(from: self, with: "\(String(describing: message))")
            }
        }
    }
    
    // MARK: - updateLOcationDetails
    func updateLocationDetails(weatherData:WeatherItemModel){
        temperatureLabel.text = weatherData.locationWeather.weatherTempString
        AppUtils.Log(from: self, with: "weatherConditionSfIcon \(String(describing: weatherData.locationWeather.weatherConditionSfIcon))")
        let iconName = weatherData.locationWeather.weatherConditionSfIcon
        self.conditionImageView.image = UIImage(systemName:iconName)
        cityLabel.text = weatherData.locationName
        
        currentTempLabel.text = WeatherUtils.formatTemperature(temperature:weatherData.locationWeather.weatherTemp)
        
        let miniTemp = weatherData.locationWeather.weatherTempMin
        let highTemp = weatherData.locationWeather.weatherTempMax
        
        miniTempLabel.text = WeatherUtils.formatTemperature(temperature: miniTemp)
        highTempLabel.text = WeatherUtils.formatTemperature(temperature: highTemp)
        let date = weatherData.locationDate
        dateLabel.text = AppUtils.formatDate(date)
    }
    
    //
    func fetchWeatherForecast(_ cityName:String){
        let trimmed = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
        OpenWeatherApiClient.fetchWeatherForecast(cityName: trimmed) { [self] status, weatherDataList, message in
            handleWeatherForecastReponse(status: status, weatherDataList: weatherDataList, message: message)
        }
    }
    
    func handleWeatherForecastReponse(status:Bool, weatherDataList:[WeatherItemModel]?, message:String?){
        if status {
            DispatchQueue.main.async { [self] in
                if let list = weatherDataList {
                    updateLocationDetails(weatherData: list.first!)
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

// MARK: - Location Manger Extention

extension WeatherViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            print(lat)
            print(long)
            OpenWeatherApiClient.fetchWeatherForecast(latitude: lat, longitude: long) { [self] success, foreCastList, message in
                handleWeatherForecastReponse(status: success, weatherDataList: foreCastList, message: message)
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

// -------------------------------------------------------------------------
// MARK: UITextField extention

extension WeatherViewController :UITextFieldDelegate {
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
}

// -------------------------------------------------------------------------
// MARK: - Table View Data Source extention

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
        
        let miniTemp = WeatherUtils.formatTemperature(temperature: weatherData.locationWeather.weatherTempMin)
        let highTemp = WeatherUtils.formatTemperature(temperature: weatherData.locationWeather.weatherTempMax)
        
        cell.weatherTempMiniLabel.text = miniTemp
        cell.weatherTemp.text = highTemp
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weatherData = self.weatherForecastList[(indexPath as NSIndexPath).row]
        performSegue(withIdentifier: "showDetails", sender: weatherData)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

