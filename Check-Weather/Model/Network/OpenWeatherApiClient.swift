//
//  OpenWeatherApiClient.swift
//  Check-Weather
//
//  Created by Awesome Jim on 09/09/2023.
//

import Foundation


protocol WeatherMangerDelegate {
    func didUpdateWeather(weatherdata :WeatherItemModel)
}

class OpenWeatherApiClient {
    
 
    enum Endpoints {
        static let base = "https://api.openweathermap.org/data/2.5/"
        static let imageBase = "https://openweathermap.org/img/wn/"
        
        
        case weatherCity(String,String)
        case forecastCity(String,String)
        case weatherCoordinates(String,String,String)
        case forecastCoordinates(String,String,String)
        case weatherIcon(String)
        
        var stringValue: String {
            switch self {
                case .weatherCity(let cityName, let apiKeyParam): return Endpoints.base + "weather?\(apiKeyParam)&\(NetworkUtilsEnum.QUERY_PARAM)=\(cityName)&\(NetworkUtilsEnum.UNITS_PARAM)=\(NetworkUtilsEnum.units)"
                    
                case .forecastCity(let cityName, let apiKeyParam): return Endpoints.base + "forecast?\(apiKeyParam)&\(NetworkUtilsEnum.QUERY_PARAM)=\(cityName)&\(NetworkUtilsEnum.UNITS_PARAM)=\(NetworkUtilsEnum.units)"
                    
                case .weatherCoordinates(let lat, let lag, let apiKeyParam): return Endpoints.base + "weather?\(apiKeyParam)&\(NetworkUtilsEnum.LAT_PARAM)=\(lat)&\(NetworkUtilsEnum.LON_PARAM)=\(lag)&\(NetworkUtilsEnum.UNITS_PARAM)=\(NetworkUtilsEnum.units)"
                    
                case .forecastCoordinates(let lat, let lag, let apiKeyParam): return Endpoints.base + "forecast?\(apiKeyParam)&\(NetworkUtilsEnum.LAT_PARAM)=\(lat)&\(NetworkUtilsEnum.LON_PARAM)=\(lag) &\(NetworkUtilsEnum.UNITS_PARAM)=\(NetworkUtilsEnum.units)"
                    
                case .weatherIcon(let icon): return Endpoints.imageBase + "\(icon)@2x.png"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    //Mark:  fetchCityWeather
    class func fetchDayWeather(cityName:String, _ completion:@escaping(_ success:Bool, _ weatherData : WeatherItemModel?, _ message:String?)-> Void) {
        //re-trive the API key form our info list
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else {
            print("Un-Able to acces API Key")
            completion(false, nil,"Un-Able to acces API Key")
            return
        }
        print(apiKey)
        
        let apiKeyParam = "\(NetworkUtilsEnum.APP_ID_PARAM)=\(apiKey)"
        
        //1. create url
        let url = OpenWeatherApiClient.Endpoints.weatherCity(cityName,apiKeyParam).url
        print(url)
        
        //2. Create a URL Session
        let session = URLSession(configuration: .default)
        
        //3. Give the session a task
        //session.dataTask(with: url, completionHandler: handle(data: respose:  error:))
        let task = session.dataTask(with: url) { data, response, error in
        
            let (rawResp, msg) = digestResponse(data, response, error)
            
            guard let responseString = rawResp else {
                // check for fundamental networking error
                AppUtils.Log(from:self,with:"REQ. error = \(String(describing: msg))")
                completion(false, nil,msg)
                return
            }
            print("responseString : \(responseString)")
            let weatherDataModel = OpenWeatherJsonUtils.getWeatherContentValuesFromJson(weatherData: responseString)
            AppUtils.Log(from:self,with:"Model Data. locationName = \(String(describing: weatherDataModel?.locationWeather.weatherTemp))")
            completion(true, weatherDataModel,"Data Loading Successfull")
        }
        
        //4. Start the Task
        task.resume()
    }
    
    //Mark:  fetchCityWeather
    class func fetchWeatherForecast(cityName:String, _ completion:@escaping(_ success:Bool, _ foreCastList : [WeatherItemModel]?, _ message:String?)-> Void) {
        //re-trive the API key form our info list
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else {
            print("Un-Able to acces API Key")
            completion(false,nil,"Invalid Service Config.")
            return
        }
        print(apiKey)
        
        let apiKeyParam = "\(NetworkUtilsEnum.APP_ID_PARAM)=\(apiKey)"
        
        //1. create url
        let url = OpenWeatherApiClient.Endpoints.forecastCity(cityName,apiKeyParam).url
       // print(url)
        
        //2. Create a URL Session
        let session = URLSession(configuration: .default)
        
        //3. Give the session a task
        //session.dataTask(with: url, completionHandler: handle(data: respose:  error:))
        let task = session.dataTask(with: url) { data, response, error in
            
            let (rawResp, msg) = digestResponse(data, response, error)
            guard let responseString = rawResp else {
                // check for fundamental networking error
                AppUtils.Log(from:self,with:"REQ. error = \(String(describing: msg))")
                completion(false,nil,msg)
                return
            }
            print("responseString : \(responseString)")
            let weatherForeCastList = OpenWeatherJsonUtils.getWeatherForecastContentValuesFromJson(weatherData: responseString)
            AppUtils.Log(from:self,with:"Model Data. ForecastItems = \(String(describing: weatherForeCastList?.count))")
            completion(true,weatherForeCastList,"Data Loading Successfull")
        }
        
        //4. Start the Task
        task.resume()
    }
    

    
    //MARK:- Default behaviour for digest Response
    class func digestResponse(_ data:Data?, _ response:URLResponse?, _ error:Error?) ->(String?,String?) {

            //
            guard let data = data, error == nil else {
                // check for fundamental networking error
                return (nil, "connection Error : \(String(describing: error))")
            }
            //
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                // check for http errors
                let _ = String(data: data, encoding: String.Encoding.utf8)
                AppUtils.Log(from:self,with:"Resp Code = \(httpStatus.statusCode), \n Failure Response: \(String(describing: httpStatus))")
                //
                return (nil, "service Error")
            }
        
            AppUtils.Log(from:self,with:"Raw Response String => \(String(describing: String(data: data, encoding: .utf8)))")
            return (String(data:data , encoding: .utf8),nil)
        
    }
    
    class func downloadWeatherIcon(path: String, completion: @escaping (Data?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: OpenWeatherApiClient.Endpoints.weatherIcon(path).url) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
        task.resume()
    }
}
