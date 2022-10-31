//
//  PresentableViewController.swift
//  TemperatureConverter
//
//  Created by maciej.helmecki on 30/10/2022.
//

import UIKit

protocol PresentableViewController {
    func toPresent() -> UIViewController
}

extension PresentableViewController where Self: UIViewController {
    func toPresent() -> UIViewController { self }
}
