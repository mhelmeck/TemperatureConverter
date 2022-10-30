//
//  HomeViewModel.swift
//  TemperatureConverter
//
//  Created by maciej.helmecki on 24/10/2022.
//

import Foundation

class HomeViewModel: ViewModel {
    typealias Input = HomeViewModelInput
    typealias Output = HomeViewModelOutput

    struct HomeViewModelInput {
        var setTemperature: ((String?) -> Void)!
        var setTypeForRow: ((Int) -> Void)!
        var convert: (() -> Void)!
    }

    struct HomeViewModelOutput {
        var temperatureTitle = String()
        var typeTitle = String()
        var result = String.none

        var pickerComponents = 1
        var picerRowsInComponent = TemperatureType.allCases.count
    }

    // MARK: - Properties
    var input: HomeViewModelInput
    var output: HomeViewModelOutput
    var emit: ((HomeViewModelOutput) -> Void)?

    private var temperatureType = TemperatureType.celsius
    private var temperature: Float?

    // MARK: - Init
    init() {
        input = HomeViewModelInput()
        output = HomeViewModelOutput()

        bindInput()
        initiateOutput()
    }
}

// MARK: - Helpers
private extension HomeViewModel {
    func bindInput() {
        input.setTemperature = { [weak self] in self?.setTemperature($0) }
        input.setTypeForRow = { [weak self] in self?.setTemperatureType(TemperatureType.allCases[$0]) }
        input.convert = { [weak self] in self?.convert() }
    }

    func initiateOutput() {
        setTemperatureType(temperatureType)
    }

    func setTemperature(_ value: String?) {
        temperature = value.flatMap { Float($0) }
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

private extension String {
    static let none = "None"
}
