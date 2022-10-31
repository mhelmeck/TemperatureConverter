//
//  ViewControllerBuilder.swift
//  TemperatureConverter
//
//  Created by maciej.helmecki on 31/10/2022.
//

import Foundation

class ViewControllerBuilder: ViewControllerBuilding {
    func buildHomeViewController() -> PresentableHomeViewController {
        let viewModel = HomeViewModel()
        let pickerDelegateDataSource = TemperatureTypePickerDelegateDataSource()

        let viewController = HomeViewController.create(
            with: viewModel,
            pickerDelegateDataSource: pickerDelegateDataSource
        )

        return viewController
    }
}
