//
//  PickerDelegateDataSource.swift
//  TemperatureConverter
//
//  Created by maciej.helmecki on 30/10/2022.
//

import UIKit

protocol PickerDelegateDataSource: UIPickerViewDelegate, UIPickerViewDataSource {
    var didSelectRow: ((Int) -> Void)? { get set }
}
