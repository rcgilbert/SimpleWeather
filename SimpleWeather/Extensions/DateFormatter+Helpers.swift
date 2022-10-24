//
//  DateFormatter+Helpers.swift
//  SimpleWeather
//
//  Created by Ryan Gilbert on 10/24/22.
//

import Foundation

extension DateFormatter {
    static var defaultDayOfWeekFormatter: DateFormatter {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("EEE")
        return df
    }
    
    static var defaultTimeFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .none
        df.timeStyle = .short
        return df
    }
}
