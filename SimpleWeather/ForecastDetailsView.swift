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
    
    var tempFormatter: MeasurementFormatter
    var dateFormatter: DateFormatter = .defaultDayOfWeekFormatter
    var timeFormatter: DateFormatter = .defaultTimeFormatter
    
    var body: some View {
        List {
            Section("Current") {
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        if let temp = weatherData?.current?.tempMeasurement {
                            Text(temp, formatter: tempFormatter)
                                .font(.title)
                        } else {
                            Text("--")
                                .font(.title)
                        }
                        Text(weatherData?.current?.formattedWeatherDescription ?? "")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        HStack {
                            if let max = weatherData?.currentMaxTempMeasurment {
                                HStack {
                                    Text("H:\(tempFormatter.string(from: max))")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            if let min = weatherData?.currentMinTempMeasurment {
                                HStack {
                                    Text("L:\(tempFormatter.string(from: min))")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    Spacer()
                }
            }
            if let hourly = weatherData?.hourly, hourly.count > 0 {
                Section("Hourly") {
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(hourly) { hour in
                                HourlyCellView(hour: hour,
                                               timeFormatter: timeFormatter,
                                               tempFormatter: tempFormatter)
                            }
                        }
                    }
                }
            }
            Section("Daily") {
                ForEach(weatherData?.daily ?? []) { day in
                    DailyCellView(day: day,
                                  dateFormatter: dateFormatter,
                                  tempFormatter: tempFormatter)
                }
            }
        }
        .navigationTitle(city.name!)
    }
}

struct DailyCellView: View {
    @State var day: Daily
    var dateFormatter: DateFormatter
    var tempFormatter: MeasurementFormatter
    
    var body: some View {
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
                    Text("H:\(tempFormatter.string(from: max))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                if let min = day.temp?.minTempMeasurement {
                    Text("L:\(tempFormatter.string(from: min))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

struct HourlyCellView: View {
    @State var hour: Current
    var timeFormatter: DateFormatter
    var tempFormatter: MeasurementFormatter
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(Date(timeIntervalSince1970: hour.dt), formatter: timeFormatter)
                .font(.subheadline)
            if let weather = hour.weather?.first {
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
            } else {
                Image(systemName: "arrow.clockwise.icloud.fill")
                    .resizable()
                    .padding(10)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 44, height: 44)
                    .opacity(0.5)
            }
            if let temp = hour.tempMeasurement {
                Text(temp, formatter: tempFormatter)
                    .font(.headline)
            } else {
                Text("--")
                    .font(.headline)
            }
        }
        .padding()
    }
}

struct ForecastDetailsView_Previews: PreviewProvider {
    @State static var weather: WeatherData? = WeatherData.mockData
    
    static var previews: some View {
        NavigationView {
            ForecastDetailsView(city: WeatherLocation.preview,
                                weatherData: $weather,
                                tempFormatter: .defaultTempFormatter)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
