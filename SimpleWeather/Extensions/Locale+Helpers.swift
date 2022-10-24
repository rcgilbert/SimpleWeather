//
//  Locale+Helpers.swift
//  SimpleWeather
//
//  Created by Ryan Gilbert on 10/21/22.
//

import Foundation

extension Locale {
    var tempuratureUnit: UnitTemperature {
        measurementSystem == .metric ? .celsius: .fahrenheit
    }
    
    var weatherUnitsString: String {
        measurementSystem == .metric ? "metric": "imperial"
    }
}
