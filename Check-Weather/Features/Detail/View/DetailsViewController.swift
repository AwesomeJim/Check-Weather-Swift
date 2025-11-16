//
//  DetailsViewController.swift
//  Check-Weather
//
//  Created by Awesome Jim on 11/09/2023.
//

import UIKit

class DetailsViewController: UIViewController {

    
    
    
    @IBOutlet weak var weatherDateLabel: UILabel!
    
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var lowTemperatureLabel: UILabel!
    @IBOutlet weak var highTemperatureLabel: UILabel!
    
    @IBOutlet weak var windMeasurementLabel: UILabel!
    
    @IBOutlet weak var weatherPressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    
    
    var dataModel : WeatherItemModel? {
        didSet {
           
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateUI()
    }
    

    // MARK: - Update UI with the set details
    func updateUI(){
        if let weatherData = dataModel {
            
            locationNameLabel.text = weatherData.locationName
            //1
            weatherDateLabel.text = AppUtils.formatDate(weatherData.locationDate)
            
            //2
            weatherDescriptionLabel.text = weatherData.locationWeather.weatherCondition
            
            //3
            let iconName = weatherData.locationWeather.weatherConditionSfIcon
            weatherIcon.image = UIImage(systemName:iconName)
            
            //4
            highTemperatureLabel.text = WeatherUtils.formatTemperature(temperature: weatherData.locationWeather.weatherTemp)
            
            //5
            lowTemperatureLabel.text = WeatherUtils.formatTemperature(temperature: weatherData.locationWeather.weatherTempMin)
            
            //6
            humidityLabel.text = WeatherUtils.getFormattedHumidity(humidity: weatherData.locationWeather.weatherHumidity)
            
            //7
            weatherPressureLabel.text = WeatherUtils.getFormattedPressure(pressure: weatherData.locationWeather.weatherPressure)
            
            
            //8
            windMeasurementLabel.text = weatherData.locationWeather.weatherWind.windSpeedString
        }
    }

}
