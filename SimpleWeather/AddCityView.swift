//
//  AddCityView.swift
//  SimpleWeather
//
//  Created by Ryan Gilbert on 10/19/22.
//

import SwiftUI
import GooglePlaces

struct AddCityView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var searchText: String = ""
    @State var predictions: [GMSAutocompletePrediction] = []
    @State var isLoading: Bool = false
    @Binding var place: GMSPlace?
    
    private let client = GMSPlacesClient()
    private let token = GMSAutocompleteSessionToken()
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(predictions) { city in
                        Button {
                            add(place: city)
                        } label: {
                            Text(AttributedString(city.attributedFullText))
                        }
                    }
                }
                .searchable(text: $searchText)
                .disabled(isLoading)
                .onChange(of: searchText) { _ in
                    updatePlaces()
                }
                if isLoading {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 100, height: 100)
                            .foregroundColor(.secondary)
                            .background(.thinMaterial)
                        ProgressView()
                            .scaleEffect(2)
                            .tint(.white)
                    }
                    
                }
            }
            .navigationTitle("Add City")
        }
    }
    
    private func add(place: GMSAutocompletePrediction) {
        isLoading = true
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                  UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.coordinate.rawValue))
        
        client.fetchPlace(fromPlaceID: place.placeID,
                          placeFields: fields,
                          sessionToken: token) { place, error in
            isLoading = false
            
            // TODO: Error handling
            if let place = place {
                self.place = place
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private func updatePlaces() {
        let filter = GMSAutocompleteFilter()
        filter.types = ["locality"]
        
        client.findAutocompletePredictions(fromQuery: searchText, filter: filter, sessionToken: token) { prediction, error in
            predictions = prediction ?? []
        }
    }
}

extension GMSAutocompletePrediction: Identifiable {
    public var id: String {
        placeID
    }
}

struct AddCityView_Previews: PreviewProvider {
    @State static var place: GMSPlace?
    
    static var previews: some View {
        AddCityView(place: $place)
    }
}

