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
    private static var API_KEY: String = ""
    
    class func configure(with apiConfig: APIConfig) {
        BASE_URL = apiConfig.weatherAPIBaseURL
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
    
    private static var languageString: String {
        Locale.current.language.minimalIdentifier
    }
    
    private static var unitsString: String {
        Locale.current.measurementSystem == .metric ? "metric": "imperial"
    }
    
    class func fetchWeather(for location: CLLocationCoordinate2D, excluding: [ReportType] = []) async throws -> WeatherData {
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
                value = unitsString
            case .lang:
                value = languageString
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
}
