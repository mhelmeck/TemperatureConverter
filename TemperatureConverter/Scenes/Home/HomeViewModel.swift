//
//  HomeViewModel.swift
//  TemperatureConverter
//
//  Created by maciej.helmecki on 24/10/2022.
//

import Foundation

class HomeViewModel: HomeInputOutput {
    typealias Output = HomeViewModelOutput

    struct HomeViewModelOutput {
        var temperatureTitle = String()
        var typeTitle = String()
        var result = String.none

        var pickerComponents = 1
        var picerRowsInComponent = TemperatureType.allCases.count
    }

    // MARK: - Properties
    var output: HomeViewModelOutput
    var emit: ((HomeViewModelOutput) -> Void)?

    private var temperatureType = TemperatureType.celsius
    private var temperature: Float?

    // MARK: - Init
    init() {
        output = HomeViewModelOutput()

        initiateOutput()
    }

    // MARK: - API
    func setTemperature(_ string: String?) {
        temperature = string.flatMap { Float($0) }
    }

    func setType(forRow row: Int) {
        temperatureType = TemperatureType.allCases[row]

        convert()
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

private extension String {
    static let none = "None"
}
