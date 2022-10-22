//
//  WeatherCellView.swift
//  SimpleWeather
//
//  Created by Ryan Gilbert on 10/21/22.
//

import SwiftUI

struct WeatherCellView: View {
    @State var name: String
    @Binding var weatherData: WeatherData?
    
    let formatter: MeasurementFormatter
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)
                    .fontWeight(.medium)
                Spacer()
                Text(weatherData?.current?.weather?.first?.weatherDescription?.capitalized ?? "")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing) {
                if let currentTemp = weatherData?.current?.tempMeasurement {
                    Text(currentTemp, formatter: formatter)
                        .font(.title)
                } else {
                    ProgressView()
                }
                Spacer()
                HStack {
                    Spacer()
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
        }.padding()
    }
}

struct WeatherCellView_Previews: PreviewProvider {
    @State static var wData: WeatherData? = WeatherData.mockData
    
    static var previews: some View {
        WeatherCellView(name: "Detroit", weatherData: $wData, formatter: .defaultTempFormatter)
            .previewDevice("iPhone 14 Pro")
            .previewLayout(.fixed(width: 300, height: 100))
    }
}
