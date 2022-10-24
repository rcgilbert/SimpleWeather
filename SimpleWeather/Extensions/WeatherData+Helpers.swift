//
//  WeatherData+Helpers.swift
//  SimpleWeather
//
//  Created by Ryan Gilbert on 10/21/22.
//

import Foundation

extension WeatherData {
    static var mockData: WeatherData {
        WeatherData(lat: 0,
                    lon: 0,
                    timezone: nil,
                    timezoneOffset: nil,
                    current: Current(dt: Date().timeIntervalSince1970, sunrise: nil, sunset: nil, temp: 42.0, feelsLike: nil, pressure: nil, humidity: nil, dewPoint: nil, uvi: nil, clouds: nil, visibility: nil, windSpeed: nil, windDeg: nil, windGust: nil, weather: [Weather(id: nil, main: nil, weatherDescription: "Party Cloudy", icon: "cloud")], pop: nil),
                    minutely: nil,
                    hourly: [Current(dt: Date().timeIntervalSince1970, sunrise: nil, sunset: nil, temp: 42.0, feelsLike: nil, pressure: nil, humidity: nil, dewPoint: nil, uvi: nil, clouds: nil, visibility: nil, windSpeed: nil, windDeg: nil, windGust: nil, weather: [Weather(id: nil, main: nil, weatherDescription: "Party Cloudy", icon: "10d")], pop: nil),
                             Current(dt: Date().timeIntervalSince1970 + 3600, sunrise: nil, sunset: nil, temp: 52.0, feelsLike: nil, pressure: nil, humidity: nil, dewPoint: nil, uvi: nil, clouds: nil, visibility: nil, windSpeed: nil, windDeg: nil, windGust: nil, weather: [Weather(id: nil, main: nil, weatherDescription: "Party Cloudy", icon: "10d")], pop: nil),
                             Current(dt: Date().timeIntervalSince1970 + 7200, sunrise: nil, sunset: nil, temp: 62.0, feelsLike: nil, pressure: nil, humidity: nil, dewPoint: nil, uvi: nil, clouds: nil, visibility: nil, windSpeed: nil, windDeg: nil, windGust: nil, weather: [Weather(id: nil, main: nil, weatherDescription: "Party Cloudy", icon: "10d")], pop: nil)],
                    daily: [Daily(dt: Date().timeIntervalSince1970, sunrise: nil, sunset: nil, moonrise: nil, moonset: nil, moonPhase: nil, temp: Temp(day: nil, min: 32, max: 72, night: nil, eve: nil, morn: nil), feelsLike: nil, pressure: nil, humidity: nil, dewPoint: nil, windSpeed: nil, windDeg: nil, windGust: nil, weather: [Weather(id: 0, main: "Rain", weatherDescription: "light rain", icon: "10d")], clouds: nil, pop: nil, rain: nil, uvi: nil)],
                    alerts: nil)
    }
    
    var currentMinTempMeasurment: Measurement<UnitTemperature>? {
        daily?.first?.temp?.minTempMeasurement
    }
    
    var currentMaxTempMeasurment: Measurement<UnitTemperature>? {
        daily?.first?.temp?.maxTempMeasurement
    }
}

extension Current {
    var tempMeasurement: Measurement<UnitTemperature>? {
        guard let temp = temp else {
            return nil
        }
        
        return Measurement(value: temp, unit: Locale.current.tempuratureUnit)
    }
    
    var formattedWeatherDescription: String? {
        weather?.first?.weatherDescription?.capitalized
    }
}

extension Temp {
    var minTempMeasurement: Measurement<UnitTemperature>? {
        guard let min = min else {
            return nil
        }
        
        return Measurement(value: min, unit: Locale.current.tempuratureUnit)
    }
    
    var maxTempMeasurement: Measurement<UnitTemperature>? {
        guard let max = max else {
            return nil
        }
        
        return Measurement(value: max, unit: Locale.current.tempuratureUnit)
    }
}
