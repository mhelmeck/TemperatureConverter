//
//  TemperatureTypePickerDelegate.swift
//  TemperatureConverter
//
//  Created by maciej.helmecki on 30/10/2022.
//

import UIKit

class TemperatureTypePickerDelegateDataSource: NSObject, PickerDelegateDataSource {
    var didSelectRow: ((Int) -> Void)?

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        ConversionType.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ConversionType.allCases[row].title
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        didSelectRow?(row)
    }
}
