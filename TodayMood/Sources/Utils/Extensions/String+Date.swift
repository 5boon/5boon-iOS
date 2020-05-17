//
//  String+Date.swift
//  TodayMood
//
//  Created by Kanz on 2020/04/02.
//

import Foundation

extension String {
    func date(dateFormat: String,
              tz: TimeZone? = .current,
              calendar: Calendar = .current) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = tz ?? .current
        dateFormatter.calendar = calendar
        return dateFormatter.date(from: self)
    }
    
    func convertServerDate() -> Date? {
        return self.date(dateFormat: Constants.DateFormats.serverFormat,
                         tz: TimeZone(identifier: "Asia/Seoul"),
                         calendar: Calendar(identifier: .gregorian))
    }
}
