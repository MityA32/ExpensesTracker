//
//  Coordinator.swift
//  ExpensesTracker
//
//  Created by Dmytro Hetman on 08.07.2024.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }
    func start()
}
