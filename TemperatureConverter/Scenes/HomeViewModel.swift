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
        var setTypeValue: ((TemperatureType) -> Void)!
        var convert: ((String?) -> Void)!
    }

    struct HomeViewModelOutput {
        var temperatureTitle = String()
        var typeTitle = String()
        var result = String.none
    }

    // MARK: - Properties
    var input: HomeViewModelInput
    var emit: ((HomeViewModelOutput) -> Void)?

    private var output: HomeViewModelOutput
    private var temperatureType = TemperatureType.degrees

    // MARK: - Init
    init() {
        input = HomeViewModelInput()
        output = HomeViewModelOutput()

        bindInput()
        initiateOutput()
    }

    // MARK: - API
    func getCurrent() -> HomeViewModelOutput { output }
}

// MARK: - Helpers
private extension HomeViewModel {
    func bindInput() {
        input.setTypeValue = { [weak self] in self?.setTypeValue($0) }
        input.convert = { [weak self] in self?.convert($0) }
    }

    func initiateOutput() {
        setTypeValue(temperatureType)
    }

    func setTypeValue(_ type: TemperatureType) {
        temperatureType = type

        switch type {
        case .fahrenheir:
            output.temperatureTitle = TemperatureType.degrees.rawValue
            output.typeTitle = TemperatureType.fahrenheir.rawValue
        case .degrees:
            output.temperatureTitle = TemperatureType.fahrenheir.rawValue
            output.typeTitle = TemperatureType.degrees.rawValue
        }

        emit?(output)
    }

    func convert(_ text: String?) {
        guard let text = text, let value = Float(text) else {
            output.result = String.none
            emit?(output)
            return
        }

        switch temperatureType {
        case .degrees:
            let result = (value - 32.0) * 5 / 9
            output.result = result.description
        case .fahrenheir:
            let result = value * (9 / 5) + 32
            output.result = result.description
        }

        emit?(output)
    }
}

private extension String {
    static let none = "None"
}
