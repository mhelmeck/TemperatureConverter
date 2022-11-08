//
//  HomeViewModel.swift
//  TemperatureConverter
//
//  Created by maciej.helmecki on 24/10/2022.
//

import Foundation

class HomeViewModel: HomeViewModelInputOutput {
    // MARK: - Output
    var output: Output
    var emit: ((Output) -> Void)?

    // MARK: - Properties
    private var conversionType = ConversionType.celsiusToFahrenheit
    private var temperature: Float?

    // MARK: - Init
    init() {
        output = Output()

        initiateOutput()
    }

    // MARK: - Input
    func setTemperature(_ string: String?) {
        temperature = string.flatMap { Float($0) }
    }

    func setConversionType(forRow row: Int) {
        conversionType = ConversionType.allCases[row]

        convert(for: conversionType)
    }

    func convert() {
        guard let temperature = temperature else {
            output.result = String.none
            emit?(output)
            return
        }

        let result = {
            switch conversionType {
            case .fahrenheitToCelsius:
                return (temperature - 32.0) * 5 / 9
            case .celsiusToFahrenheit:
                return temperature * (9 / 5) + 32
            }
        }()
        output.result = String(format: "%.2f", result)

        emit?(output)
    }
}

// MARK: - Helpers
private extension HomeViewModel {
    func initiateOutput() {
        convert(for: conversionType)
    }

    func convert(for conversionType: ConversionType) {
        self.conversionType = conversionType

        output.conversionTypeTitle = conversionType.title
        output.convertToTitle = conversionType.toDescription
        output.convertFromTitle = conversionType.fromDescription

        convert()
    }
}
