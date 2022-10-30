//
//  HomeViewModel.swift
//  TemperatureConverter
//
//  Created by maciej.helmecki on 24/10/2022.
//

import Foundation

class HomeViewModel: ViewModel {
    // MARK: - Properties
    var input: HomeViewModelInput
    var updateOutput: ((HomeViewModelOutput) -> Void)?

    private var output: HomeViewModelOutput
    private var temperatureType = TemperatureType.degrees

    // MARK: - Init
    init() {
        input = HomeViewModelInput()
        output = HomeViewModelOutput()

        bindInput()
        initiateOutput()
    }

    private func bindInput() {
        input.setTypeValue = { [weak self] in self?.setTypeValue($0) }
        input.convert = { [weak self] in self?.convert($0) }
    }

    private func initiateOutput() {
        setTypeValue(temperatureType)
    }

    // MARK: - Methods
    private func setTypeValue(_ type: TemperatureType) {
        temperatureType = type

        switch type {
        case .fahrenheir:
            output.temperatureTitleLabel = TemperatureType.degrees.rawValue
            output.typeValueLabel = TemperatureType.fahrenheir.rawValue
        case .degrees:
            output.temperatureTitleLabel = TemperatureType.fahrenheir.rawValue
            output.typeValueLabel = TemperatureType.degrees.rawValue
        }

        updateOutput?(output)
    }

    private func convert(_ text: String?) {
        guard let text = text, let value = Float(text) else {
            output.resultValue = String()
            updateOutput?(output)
            return
        }

        switch temperatureType {
        case .degrees:
            let result = (value - 32.0) * 5 / 9
            output.resultValue = result.description
        case .fahrenheir:
            let result = value * (9 / 5) + 32
            output.resultValue = result.description
        }

        updateOutput?(output)
    }
}

// MARK: - ViewModel
extension HomeViewModel {
    typealias Input = HomeViewModelInput
    typealias Output = HomeViewModelOutput

    struct HomeViewModelInput {
        var setTypeValue: ((TemperatureType) -> Void)!

        var convert: ((String?) -> Void)!
    }

    struct HomeViewModelOutput {
        var temperatureTitleLabel = String()
        var typeValueLabel = String()
        var resultValue = String()
    }

    func getCurrent() -> HomeViewModelOutput { output }
}
