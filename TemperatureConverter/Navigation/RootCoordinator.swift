//
//  RootCoordinator.swift
//  TemperatureConverter
//
//  Created by maciej.helmecki on 18/10/2022.
//

import UIKit

class RootCoordinator: Coordinator {
    // MARK: - Properties
    var childCoordinators: [Coordinator] = []
    var rootNavigationController: UINavigationController

    // MARK: - Init
    init(rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
    }

    // MARK: - Methods
    func start() {
        let homeVC = HomeViewController()

        rootNavigationController.setViewControllers([homeVC], animated: true)
    }
}
