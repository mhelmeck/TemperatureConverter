//
//  ViewModel.swift
//  TemperatureConverter
//
//  Created by maciej.helmecki on 24/10/2022.
//

import Foundation

protocol ViewModel {
    associatedtype Input
    associatedtype Output

    var input: Input { get set }
    var emit: ((Output) -> Void)? { get set }

    func getCurrent() -> Output
}
