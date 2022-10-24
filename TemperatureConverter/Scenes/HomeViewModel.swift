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

    private func convert(_ value: Float) {
        switch temperatureType {
        case .degrees:
            output.resultValue = (value - 32.0) * 5/9
        case .fahrenheir:
            output.resultValue = value * (9/5) + 32
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

        var convert: ((Float) -> Void)!
    }

    struct HomeViewModelOutput {
        var temperatureTitleLabel = String()
        var typeValueLabel = String()
        var resultValue = Float()
    }
}
