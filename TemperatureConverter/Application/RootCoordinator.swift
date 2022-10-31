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

    let viewControllerBuilder: ViewControllerBuilding

    // MARK: - Init
    init(rootNavigationController: UINavigationController, viewControllerBuilder: ViewControllerBuilding) {
        self.rootNavigationController = rootNavigationController
        self.viewControllerBuilder = viewControllerBuilder
    }

    // MARK: - Methods
    func start() {
        let homeVC = viewControllerBuilder.buildHomeViewController()

        rootNavigationController.setViewControllers([homeVC.toPresent()], animated: true)
    }
}
