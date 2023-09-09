//
//  ConstantsEnum.swift
//  Check-Weather
//
//  Created by Awesome Jim on 09/09/2023.
//


enum ConstantsEnum {
    /* Weather information. Each day's forecast info is an element of the "list" array */
    static let OWM_LIST = "list"
    
    /* Location information */
    static let OWM_CITY_NAME = "name"
    static let OWM_CITY_ID = "id"
    static let OWM_CITY = "city"
    
    /* Location coordinate */
    static let OWM_COORD = "coord"
    static let OWM_LATITUDE = "lat"
    static let OWM_LONGITUDE = "lon"
    
    /* Location wind */
    static let OWM_WIND = "wind"
    static let OWM_MAIN = "main"
    static let OWM_PRESSURE = "pressure"
    static let OWM_HUMIDITY = "humidity"
    static let OWM_WINDSPEED = "speed"
    static let OWM_WIND_DIRECTION = "deg"
    
    /* All temperatures are children of the "temp" object */
    static let OWM_TEMPERATURE = "temp"
    
    /* Max temperature for the day */
    static let OWM_MAX = "temp_max"
    static let OWM_MIN = "temp_min"
    static let OWM_WEATHER = "weather"
    static let OWM_WEATHER_ID = "id"
    static let OWM_MESSAGE_CODE = "cod"
    
    static let INDEX_WEATHER_DATE = 0
    static let INDEX_WEATHER_MAX_TEMP = 1
    static let INDEX_WEATHER_MIN_TEMP = 2
    static let INDEX_WEATHER_CONDITION_ID = 3
}
