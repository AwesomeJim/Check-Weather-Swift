//
//  OpenWeatherApiClient.swift
//  Check-Weather
//
//  Created by Awesome Jim on 09/09/2023.
//

import Foundation




class OpenWeatherApiClient {
    
    
    
    enum Endpoints {
        static let base = "https://api.openweathermap.org/data/2.5/"
        
        
        case weatherCity(String,String)
        case forecastCity(String,String)
        case weatherCoordinates(String,String,String)
        case forecastCoordinates(String,String,String)
        
        var stringValue: String {
            switch self {
                case .weatherCity(let cityName, let apiKeyParam): return Endpoints.base + "weather?\(apiKeyParam)&\(NetworkUtilsEnum.QUERY_PARAM)=\(cityName)&\(NetworkUtilsEnum.UNITS_PARAM)=\(NetworkUtilsEnum.units)"
                    
                case .forecastCity(let cityName, let apiKeyParam): return Endpoints.base + "forecast?\(apiKeyParam)&\(NetworkUtilsEnum.QUERY_PARAM)=\(cityName)&\(NetworkUtilsEnum.UNITS_PARAM)=\(NetworkUtilsEnum.units)"
                    
                case .weatherCoordinates(let lat, let lag, let apiKeyParam): return Endpoints.base + "weather?\(apiKeyParam)&\(NetworkUtilsEnum.LAT_PARAM)=\(lat)&\(NetworkUtilsEnum.LON_PARAM)=\(lag)&\(NetworkUtilsEnum.UNITS_PARAM)=\(NetworkUtilsEnum.units)"
                    
                case .forecastCoordinates(let lat, let lag, let apiKeyParam): return Endpoints.base + "forecast?\(apiKeyParam)&\(NetworkUtilsEnum.LAT_PARAM)=\(lat)&\(NetworkUtilsEnum.LON_PARAM)=\(lag) &\(NetworkUtilsEnum.UNITS_PARAM)=\(NetworkUtilsEnum.units)"
                    
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    //Mark:  fetchCityWeather
    class func fetchWeather(cityName:String){
        //re-trive the API key form our info list
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else {
            print("Un-Able to acces API Key")
            return
        }
        print(apiKey)
        
        let apiKeyParam = "\(NetworkUtilsEnum.APP_ID_PARAM)=\(apiKey)"
        
        //1. create url
        let url = OpenWeatherApiClient.Endpoints.weatherCity(cityName,apiKeyParam).url
        print(url)
        
        //2. Create a URL Session
        let session = URLSession(configuration: .default)
        
        //       //3. Give the session a task
        //       let task = session.dataTask(with: url, completionHandler: <#T##(Data?, URLResponse?, Error?) -> Void#>)
        //
        //       //4. Start the Task
        //       task.resume()
    }
}
