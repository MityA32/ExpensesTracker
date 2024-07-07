//
//  AppCoordinator.swift
//  ExpensesTracker
//
//  Created by Dmytro Hetman on 04.07.2024.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }
    func start()
}

final class AppCoordinator: Coordinator {
    private var window: UIWindow
    let navigationController = UINavigationController()
    
    init(window: UIWindow) {
        self.window = window
        navigationController.navigationBar.isHidden = true
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
    
    func start() {
        showMain()
    }
    
    private func showMain() {

        let mainPageViewModel = MainPageViewModel(exchangeRateModel: .init(), coredataService: CoreDataService.shared)
        let mainViewController = ViewController(viewModel: mainPageViewModel)
        navigationController.viewControllers = [mainViewController]
    }
    
    private func showAddTransaction() {
        
        
        
    }
}

