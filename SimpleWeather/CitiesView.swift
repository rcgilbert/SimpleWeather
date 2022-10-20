//
//  CitiesView.swift
//  SimpleWeather
//
//  Created by Ryan Gilbert on 10/19/22.
//

import SwiftUI
import GooglePlaces

struct CitiesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WeatherLocation.order, ascending: true),
                          NSSortDescriptor(keyPath: \WeatherLocation.name, ascending: true)],
        animation: .default)
    private var cities: FetchedResults<WeatherLocation>
    
    @State var showAddCity: Bool = false
    @State var place: GMSPlace?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(cities) { city in
                    Text(city.name!)
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Cities")
            .toolbar {
                ToolbarItem {
                    Button("Add City") {
                        showAddCity.toggle()
                    }
                }
            }
            .sheet(isPresented: $showAddCity) {
                AddCityView(place: $place)
            }
            .onChange(of: place, perform: add)
        }
    }
    
    private func add(city: GMSPlace?) {
        guard let city = city else {
            return
        }
        
        withAnimation {
            let newItem = WeatherLocation(context: viewContext)
            newItem.name = city.name
            newItem.latitude = city.coordinate.latitude
            newItem.longitude = city.coordinate.longitude
            newItem.order = Int32((try? viewContext.count(for: WeatherLocation.fetchRequest())) ?? 0) + 1
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
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { cities[$0] }.forEach(viewContext.delete)

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
}

struct CitiesView_Previews: PreviewProvider {
    static var previews: some View {
        CitiesView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
