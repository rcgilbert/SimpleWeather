//
//  WeatherLocation+Helpers.swift
//  SimpleWeather
//
//  Created by Ryan Gilbert on 10/19/22.
//

import Foundation
import CoreLocation

extension WeatherLocation {
    static var preview: WeatherLocation {
        let city = WeatherLocation(context: PersistenceController.preview.container.viewContext)
        city.name = "Detroit"
        city.order = 0
        city.latitude = 42.3314
        city.longitude = -83.0458
        return city
    }
    
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var latLongString: String {
        "\(latitude),\(longitude)"
    }
}
