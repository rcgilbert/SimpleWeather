//
//  WeatherClient.swift
//  SimpleWeather
//
//  Created by Ryan Gilbert on 10/19/22.
//

import Foundation
import CoreLocation

final class WeatherClient {
    // MARK: - Config
    private static var BASE_URL: String = ""
    private static var ICON_BASE_URL: String = ""
    private static var API_KEY: String = ""
    
    class func configure(with apiConfig: APIConfig) {
        BASE_URL = apiConfig.weatherAPIBaseURL
        ICON_BASE_URL = apiConfig.weatherIconBaseURL
        API_KEY = apiConfig.weatherAPIKey
    }
    
    // MARK: - API Calls
    
    /// Parameter Names for Weather API
    private enum WeatherParameter: String, CaseIterable {
        case lat
        case lon
        case appId = "appid"
        case exclude
        case units
        case lang
        
        func queryParameter(for value: String) -> URLQueryItem {
            URLQueryItem(name: rawValue, value: value)
        }
    }
    
    /// Report types to exlude from weather response
    enum ReportType: String {
        case current
        case minutely
        case hourly
        case daily
        case alerts
    }
    
    /// Errors thrown when attempting to fetch the weather
    enum WeatherError: Error {
        case invalidURL(_ url: String)
        case responseError(response: URLResponse)
    }
    
    private static let session: URLSession = .shared
    private static let jsonDecoder = JSONDecoder()
    
    /// Fetch weather data for a particular location.
    /// - Parameter location: The coordinates to retrieve weather data for.
    /// - Parameter excludiing: Data types to exlude in weather response. Default is to include everything.
    /// - Parameter locale: The locale used to localize weather data. Default is current device locale.
    class func fetchWeather(for location: CLLocationCoordinate2D, excluding: [ReportType] = [], locale: Locale = .current) async throws -> WeatherData {
        // Build URL Request
        guard var urlComponents = URLComponents(string: BASE_URL) else {
            throw WeatherError.invalidURL(BASE_URL)
        }
        
        var parameters = urlComponents.queryItems ?? []
        for param in WeatherParameter.allCases {
            var value: String
            switch param {
            case .lat:
                value = String(location.latitude)
            case .lon:
                value = String(location.longitude)
            case .appId:
                value = API_KEY
            case .exclude:
                value = excluding.reduce("") { partialResult, reportType in
                    return partialResult + ",\(reportType.rawValue)"
                }
            case .units:
                value = locale.weatherUnitsString
            case .lang:
                value = locale.language.minimalIdentifier
            }
            
            parameters.append(URLQueryItem(name: param.rawValue, value: value))
        }
        
        urlComponents.queryItems = parameters
        
        guard let url = urlComponents.url else {
            throw WeatherError.invalidURL(urlComponents.string ?? "")
        }
        
        let request = URLRequest(url: url)
        
        // Execute Request
        let (data, response) = try await session.data(for: request)
        
        // Make sure we got a success response
        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            throw WeatherError.responseError(response: response)
        }
        
        // Decode API data
        return try jsonDecoder.decode(WeatherData.self, from: data)
    }
    
    /// Generates a URL to fetch an icon for a weather forecast.
    /// - Parameter weather: the `Weather` object to generate an icon URL for. 
    class func iconURL(for weather: Weather) -> URL? {
        guard var urlComponents = URLComponents(string: ICON_BASE_URL),
              let iconName = weather.icon else {
            return nil
        }
        
        urlComponents.path.append("/\(iconName)@2x.png")
        return urlComponents.url
    }
}
