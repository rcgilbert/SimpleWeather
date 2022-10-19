//
//  SimpleWeatherApp.swift
//  SimpleWeather
//
//  Created by Ryan Gilbert on 10/19/22.
//

import SwiftUI

@main
struct SimpleWeatherApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
