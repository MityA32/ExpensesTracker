//
//  AppCoordinator.swift
//  ExpensesTracker
//
//  Created by Dmytro Hetman on 04.07.2024.
//

import UIKit

final class AppCoordinator: Coordinator {
    private let window = UIWindow(frame: UIScreen.main.bounds)
    let navigationController = UINavigationController()
    
    init() {
        navigationController.navigationBar.isHidden = true
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func start() {
        showMain()
    }
    
    private func showMain() {
        let mainPageViewModel = MainPageViewModel(exchangeRateModel: .init(), coredataService: CoreDataService.shared)
        let mainViewController = MainPageViewController(viewModel: mainPageViewModel)
        navigationController.viewControllers = [mainViewController]
    }

}

