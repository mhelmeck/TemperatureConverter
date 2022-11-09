//
//  ConversionType.swift
//  TemperatureConverter
//
//  Created by maciej.helmecki on 24/10/2022.
//

import Foundation

enum ConversionType: CaseIterable {
    case celsiusToFahrenheit
    case fahrenheitToCelsius

    var title: String {
        switch self {
        case .celsiusToFahrenheit:
            return "Celsius to Fahrenheit"
        case .fahrenheitToCelsius:
            return "Fahrenheit to Celsius"
        }
    }

    var toDescription: String {
        switch self {
        case .celsiusToFahrenheit:
            return "To (Fahrenheit):"
        case .fahrenheitToCelsius:
            return "To (Celsius):"
        }
    }

    var fromDescription: String {
        switch self {
        case .celsiusToFahrenheit:
            return "From (Celsius):"
        case .fahrenheitToCelsius:
            return "From (Fahrenheit):"
        }
    }
}
