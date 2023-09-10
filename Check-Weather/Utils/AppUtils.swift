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
    
}

