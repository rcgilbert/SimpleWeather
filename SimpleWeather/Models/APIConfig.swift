//
//  APIConfig.swift
//  SimpleWeather
//
//  Created by Ryan Gilbert on 10/19/22.
//

import Foundation

struct APIConfig: Decodable {
    let weatherAPIBaseURL: String
    let weatherAPIKey: String
    let googlePlacesAPIKey: String
    
    enum CodingKeys: String, CodingKey {
        case weatherAPIBaseURL = "Weather_Base_URL"
        case weatherAPIKey = "Weather_API_Key"
        case googlePlacesAPIKey = "Google_Places_API_Key"
    }
}
