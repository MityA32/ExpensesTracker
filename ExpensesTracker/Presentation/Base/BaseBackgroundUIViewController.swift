//
//  BaseBackgroundUIViewController.swift
//  ExpensesTracker
//
//  Created by Dmytro Hetman on 04.07.2024.
//

import UIKit

class BaseBackgroundUIViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
    }
    
    private func setupBackground() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.hex0A0A7A.cgColor, UIColor.hex2121BD.cgColor]

        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)

        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
    }
    
}
