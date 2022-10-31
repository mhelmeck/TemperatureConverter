//
//  HomeViewModelInputOutput.swift
//  TemperatureConverter
//
//  Created by maciej.helmecki on 30/10/2022.
//

import Foundation

typealias HomeViewModelInputOutput = HomeViewModelInput & HomeViewModelOutput

protocol HomeViewModelInput {
    func setTemperature(_ string: String?)
    func setType(forRow row: Int)
    func convert()
}

protocol HomeViewModelOutput {
    var output: HomeViewModel.Output { get set }
    var emit: ((HomeViewModel.Output) -> Void)? { get set }
}

extension HomeViewModel {
    struct Output {
        var temperatureTitle = String()
        var typeTitle = String()
        var result = String.none

        var pickerComponents = 1
        var picerRowsInComponent = TemperatureType.allCases.count
    }
}
