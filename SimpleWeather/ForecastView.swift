//
//  ForecastView.swift
//  SimpleWeather
//
//  Created by Ryan Gilbert on 10/19/22.
//

import SwiftUI
import CoreData

struct ForecastView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WeatherLocation.order, ascending: true),
                          NSSortDescriptor(keyPath: \WeatherLocation.name, ascending: true)],
        animation: .default)
    private var cities: FetchedResults<WeatherLocation>
    @State private var weatherDataForCity: [String: WeatherData] = [:]
    @State private var showListOfCities: Bool = false
    private let formatter: MeasurementFormatter = .defaultTempFormatter
    
    var body: some View {
        NavigationView {
            List {
                ForEach(cities) { city in
                    Section {
                        NavigationLink {
                            ForecastDetailsView(city: city,
                                                weatherData: $weatherDataForCity[city.latLongString], tempFormatter: formatter)
                        } label: {
                            VStack {
                                WeatherCellView(name: city.name!,
                                                weatherData: $weatherDataForCity[city.latLongString], formatter: formatter)
                            }
                        }
                    }
                }
                .onMove(perform: move)
            }
            .navigationTitle("Simple Weather")
            .toolbar {
                ToolbarItem {
                    Button {
                        showListOfCities.toggle()
                    } label: {
                        Text("List of Cities")
                    }
                }
            }
            .onReceive(cities.publisher) { city in
                Task {
                    await fetchWeather(for: city)
                }
            }
            .sheet(isPresented: $showListOfCities) {
                CitiesView()
            }
            .refreshable {
                await fetchAllWeather()
            }
        }
    }
    
    private func fetchAllWeather() async {
        for city in cities {
            await fetchWeather(for: city)
        }
    }
    
    private func fetchWeather(for city: WeatherLocation) async {
        print("Fetching Weather for \(city.name!)")
        do {
            let weather = try await WeatherClient.fetchWeather(for: city.coordinates,
                                                               excluding: [.alerts, .minutely])
            withAnimation {
                weatherDataForCity[city.latLongString] = weather
            }
        } catch {
            print(error)
            // TODO: Error handling
        }
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        // Make an array of items from fetched results
        var revisedItems = cities.map { $0 }
        
        // change the order of the items in the array
        revisedItems.move(fromOffsets: source, toOffset: destination )
        
        // update the userOrder attribute in revisedItems to
        // persist the new order. This is done in reverse order
        // to minimize changes to the indices.
        for reverseIndex in stride(from: revisedItems.count - 1,
                                   through: 0,
                                   by: -1) {
            revisedItems[reverseIndex].order = Int32(reverseIndex)
        }
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
