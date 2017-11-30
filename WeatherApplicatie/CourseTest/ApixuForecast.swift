//
//  ApixuForecast.swift
//  WeatherApplication
//
//  Created by Geart on 28/11/2017.
//  Copyright © 2017 Geart. All rights reserved.
//

import Foundation
struct Location: Decodable {
    let name: String
}
struct ApixuForecast2: Decodable {
    public var location: Location

    let current: CurrentWeather
    struct CurrentWeather: Decodable{
        let temp_c: Double
        let condition: Condition
        struct Condition: Decodable{
            let icon: String
            let text: String
        }
    }
    let forecast: Forecast
    struct Forecast:Decodable {
        public let forecastday: [forecastday]
        struct forecastday: Decodable {
            let date: String
            let day: WeatherInformationDay
            struct WeatherInformationDay:Decodable {
                let avgtemp_c: Double
                let condition: Condition
                struct Condition:Decodable {
                    let text: String
                    let icon: String
                }
            }
        }
    }
}
