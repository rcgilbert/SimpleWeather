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
    
    private let measurementFormatter = MeasurementFormatter()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(cities) { item in
                    NavigationLink {
                        // TODO: Weather Details
                    } label: {
                        VStack(alignment: .leading) {
                            Text(item.name!)
                            if let temp = weatherFor(city: item)?.current?.temp,
                               // TODO: FIX UNITS
                               let tempMeasurement = Measurement(value: temp, unit: UnitTemperature.fahrenheit) {
                                Text(tempMeasurement, formatter: measurementFormatter)
                            }
                        }
                    }
                }
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
            .sheet(isPresented: $showListOfCities) {
                CitiesView()
            }
            .refreshable {
                await fetchWeather()
            }
            .onAppear {
                Task {
                   await fetchWeather()
                }
            }
        }
    }

    private func weatherFor(city: WeatherLocation) -> WeatherData? {
        weatherDataForCity[city.latLongString]
    }
    
    private func fetchWeather() async {
        for city in cities {
            do {
                let weather = try await WeatherClient.fetchWeather(for: city.coordinates,
                                                                   excluding: [.alerts, .daily, .hourly, .minutely])
                withAnimation {
                    weatherDataForCity[city.latLongString] = weather
                }
            } catch {
                print(error)
                // TODO: Error handling
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
