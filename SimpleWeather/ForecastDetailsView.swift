//
//  ForecastDetailsView.swift
//  SimpleWeather
//
//  Created by Ryan Gilbert on 10/19/22.
//

import SwiftUI

struct ForecastDetailsView: View {
    @State var city: WeatherLocation
    @Binding var weatherData: WeatherData?
    
    var formatter: MeasurementFormatter
    var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("EEE")
        return df
    }()
    
    var body: some View {
        List {
            Section("Current") {
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        if let temp = weatherData?.current?.tempMeasurement {
                            Text(temp, formatter: formatter)
                                .font(.title)
                        } else {
                            Text("--")
                                .font(.title)
                        }
                        Text(weatherData?.current?.weather?.first?.weatherDescription?.capitalized ?? "")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        HStack {
                            if let max = weatherData?.daily?.first?.temp?.maxTempMeasurement {
                                HStack {
                                    Text("H:\(formatter.string(from: max))")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            if let min = weatherData?.daily?.first?.temp?.minTempMeasurement {
                                HStack {
                                    Text("L:\(formatter.string(from: min))")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    Spacer()
                }
            }
            Section("Daily") {
                ForEach(weatherData?.daily ?? []) { day in
                    HStack {
                        Text(Date(timeIntervalSince1970: day.dt), formatter: dateFormatter)
                            .frame(minWidth: 44)
                        Spacer()
                        if let weather = day.weather?.first {
                            AsyncImage(url: WeatherClient.iconURL(for: weather)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 44, maxHeight: 44)
                            } placeholder: {
                                Image(systemName: "arrow.clockwise.icloud.fill")
                                    .resizable()
                                    .padding(10)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 44, height: 44)
                                    .opacity(0.5)
                            }
                        }
                        Spacer()
                        Spacer()
                        HStack() {
                            if let max = day.temp?.maxTempMeasurement {
                                Text("H:\(formatter.string(from: max))")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            
                            if let min = day.temp?.minTempMeasurement {
                                Text("L:\(formatter.string(from: min))")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .navigationTitle(city.name!)
    }
}

struct ForecastDetailsView_Previews: PreviewProvider {
    @State static var weather: WeatherData? = WeatherData.mockData
    
    static var previews: some View {
        NavigationView {
            ForecastDetailsView(city: WeatherLocation.preview,
                                weatherData: $weather,
                                formatter: .defaultTempFormatter)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
