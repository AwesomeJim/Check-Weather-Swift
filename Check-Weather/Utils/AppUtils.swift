//
//  AppUtils.swift
//  Check-Weather
//
//  Created by Awesome Jim on 10/09/2023.
//

import Foundation
import UIKit

public class AppUtils {
    
    static var TAG:String = "AppUtils : "
    
    
    public static func Log(from obj:AnyObject, with :String){
        
        //os_log("\(type(of: obj)) ", log: log, " |:> \(with)")
        debugPrint("\(String(describing: type(of: obj))) |:> \(with)")
    }
    
    public static func convertUTCToDayOfMonth(utcTime: Date) -> Int {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        let dayOfMonth = calendar.component(.day, from: utcTime)
        return dayOfMonth
    }
    
    public static func getDayOfMonth() -> Int {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        let dayOfMonth = calendar.component(.day, from: Date())
        return dayOfMonth
    }
    
    
    
    public static func getDateString(from date:Date, dateFormatter:DateFormatter) -> String{
        //
        let pars = Calendar.current.dateComponents([.day, .year, .month], from: date)
        
        //
        if pars.year == Calendar.current.dateComponents([.day, .year, .month], from: Date()).year{
            //
            if pars.month == Calendar.current.dateComponents([.day, .year, .month], from: Date()).month{
                dateFormatter.dateFormat = "HH:mm aa"
                //
                if pars.day == Calendar.current.dateComponents([.day, .year, .month], from: Date()).day{
                    //
                    return "Today, \(dateFormatter.string(from: date))"
                }else if pars.day == Calendar.current.dateComponents([.day, .year, .month], from: Calendar.current.date(byAdding: .day, value: 1, to: Date())!).day{
                    //
                    return "Tomorrow, \(dateFormatter.string(from: date))"
                }else {
                    dateFormatter.dateFormat = "EEE, d MMM yyyy"
                    return "\(dateFormatter.string(from: date))"
                }
            }
        }
        //
        return dateFormatter.string(from: date)
    }
    
    public static func formatDate(_ utcTimeMili:Double) ->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, d MMM yyyy"
        let utcTime = Date(timeIntervalSince1970: utcTimeMili) // 2023-09-10 00:00:00 UTC
        
        return getDateString(from: utcTime, dateFormatter: dateFormatter)
    }
    
    
    
}

