//
//  Coordinator.swift
//  TemperatureConverter
//
//  Created by maciej.helmecki on 18/10/2022.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var rootNavigationController: UINavigationController { get set }

    func start()
}
