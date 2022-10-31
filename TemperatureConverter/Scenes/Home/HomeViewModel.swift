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
    private var temperatureType = TemperatureType.celsius
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

    func setType(forRow row: Int) {
        temperatureType = TemperatureType.allCases[row]

        setTemperatureType(temperatureType)
    }

    func convert() {
        guard let temperature = temperature else {
            output.result = String.none
            emit?(output)
            return
        }

        switch temperatureType {
        case .celsius:
            let result = (temperature - 32.0) * 5 / 9
            output.result = result.description
        case .fahrenheir:
            let result = temperature * (9 / 5) + 32
            output.result = result.description
        }

        emit?(output)
    }
}

// MARK: - Helpers
private extension HomeViewModel {
    func initiateOutput() {
        setTemperatureType(temperatureType)
    }

    func setTemperatureType(_ type: TemperatureType) {
        temperatureType = type

        switch type {
        case .fahrenheir:
            output.temperatureTitle = TemperatureType.celsius.rawValue
            output.typeTitle = TemperatureType.fahrenheir.rawValue
        case .celsius:
            output.temperatureTitle = TemperatureType.fahrenheir.rawValue
            output.typeTitle = TemperatureType.celsius.rawValue
        }

        convert()
    }
}
