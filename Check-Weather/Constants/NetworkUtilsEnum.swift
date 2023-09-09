//
//  NetworkUtilsEnum.swift
//  Check-Weather
//
//  Created by Awesome Jim on 09/09/2023.
//


enum NetworkUtilsEnum {
    
    /* The format we want our API to return */
    static let format = "json"
    
    /* The units we want our API to return */
    static let units = "metric"
    
    
    /* The query parameter allows us to provide a location string to the API */
    static let QUERY_PARAM = "q"
    static let LAT_PARAM = "lat"
    static let LON_PARAM = "lon"
    
    /* The format parameter allows us to designate whether we want JSON or XML from our API */
    static let FORMAT_PARAM = "mode"
    
    /* The units parameter allows us to designate whether we want metric units or imperial units */
    static let UNITS_PARAM = "units"
    
    /* The days parameter allows us to designate how many days of weather data we want */
    static let DAYS_PARAM = "cnt"
    
    /* The query parameter allows us to provide a App id*/
    static let APP_ID_PARAM = "appid"
    
}
