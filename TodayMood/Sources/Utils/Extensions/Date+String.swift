//
//  Date+String.swift
//  TodayMood
//
//  Created by Kanz on 2020/04/12.
//

import Foundation
import UIKit

extension Date {
    
    // MARK: String
    func string(dateFormat: String,
                tz: TimeZone? = .current,
                calendar: Calendar? = Calendar(identifier: .gregorian)) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.calendar = calendar
        // dateFormatter.timeZone = tz ?? TimeZone(abbreviation: "UTC")
        dateFormatter.timeZone = tz ?? TimeZone(identifier: "Asia/Seoul")
        return dateFormatter.string(from: self)
    }
    
    // MARK: - DateComponents
    func components(calendar: Calendar = Calendar(identifier: .gregorian)) -> DateComponents {
        // let timeZone = TimeZone(abbreviation: "UTC") ?? .current
        let timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current
        return calendar.dateComponents(in: timeZone, from: self)
    }
    
    // MARK: Add Date
    func add(_ component: Calendar.Component, value: Int) -> Date? {
        return Calendar(identifier: .gregorian).date(byAdding: component, value: value, to: self)
    }
}
