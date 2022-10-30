//
//  Configurable.swift
//  TemperatureConverter
//
//  Created by maciej.helmecki on 18/10/2022.
//

import UIKit

protocol Configurable {}

extension Configurable where Self: UIView {
    func configure(_ configuration: (Self) -> Void) -> Self {
        configuration(self)
        self.translatesAutoresizingMaskIntoConstraints = false

        return self
    }
}
