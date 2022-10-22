//
//  MeasurementFormatter+Helpers.swift
//  SimpleWeather
//
//  Created by Ryan Gilbert on 10/21/22.
//

import Foundation

extension MeasurementFormatter {
    static var defaultTempFormatter: MeasurementFormatter {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.numberFormatter.roundingMode = .halfUp
        formatter.numberFormatter.maximumFractionDigits = 0
        return formatter
    }
}
