//
//  WeatherLocation+Helpers.swift
//  SimpleWeather
//
//  Created by Ryan Gilbert on 10/19/22.
//

import Foundation
import CoreLocation

extension WeatherLocation {
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var latLongString: String {
        "\(latitude),\(longitude)"
    }
}
