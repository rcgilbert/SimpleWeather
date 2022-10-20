//
//  SimpleWeatherApp.swift
//  SimpleWeather
//
//  Created by Ryan Gilbert on 10/19/22.
//

import SwiftUI
import GooglePlaces

@main
struct SimpleWeatherApp: App {
    let persistenceController = PersistenceController.shared

    init() {
        configureAPIs()
    }
    
    var body: some Scene {
        WindowGroup {
            ForecastView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
    private func configureAPIs() {
        guard let configFileURL = Bundle.main.url(forResource: "API-Config", withExtension: "plist"),
              let configData = try? Data(contentsOf: configFileURL),
              let apiConfig = try? PropertyListDecoder().decode(APIConfig.self, from: configData) else {
            assertionFailure("Missing or Invalid API Config!")
            return
        }
        
        GMSPlacesClient.provideAPIKey(apiConfig.googlePlacesAPIKey)
        WeatherClient.configure(with: apiConfig)
    }
}
