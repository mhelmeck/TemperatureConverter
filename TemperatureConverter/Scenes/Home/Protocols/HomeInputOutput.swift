//
//  HomeInputOutput.swift
//  TemperatureConverter
//
//  Created by maciej.helmecki on 30/10/2022.
//

import Foundation

protocol HomeInputOutput: ViewModelOutput {
    func setTemperature(_ string: String?)
    func setType(forRow row: Int)
    func convert()
}
