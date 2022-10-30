//
//  ViewModelOutput.swift
//  TemperatureConverter
//
//  Created by maciej.helmecki on 24/10/2022.
//

import Foundation

protocol ViewModelOutput {
    associatedtype Output

    var output: Output { get set }
    var emit: ((Output) -> Void)? { get set }
}
