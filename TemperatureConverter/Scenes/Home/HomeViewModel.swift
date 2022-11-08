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
    private var temperatureResultType = TemperatureType.celsius
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

    func setTemperatureResultType(forRow row: Int) {
        temperatureResultType = TemperatureType.allCases[row]

        convert(forResultType: temperatureResultType)
    }

    func convert() {
        guard let temperature = temperature else {
            output.result = String.none
            emit?(output)
            return
        }

        let result = {
            switch temperatureResultType {
            case .celsius:
                return (temperature - 32.0) * 5 / 9
            case .fahrenheit:
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
        convert(forResultType: temperatureResultType)
    }

    func convert(forResultType resultType: TemperatureType) {
        temperatureResultType = resultType

        switch resultType {
        case .fahrenheit:
            output.convertToTitle = TemperatureType.fahrenheit.rawValue
            output.convertFromTitle = TemperatureType.celsius.rawValue
        case .celsius:
            output.convertToTitle = TemperatureType.celsius.rawValue
            output.convertFromTitle = TemperatureType.fahrenheit.rawValue
        }

        convert()
    }
}
