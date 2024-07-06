//
//  MainPageBalanceView.swift
//  ExpensesTracker
//
//  Created by Dmytro Hetman on 06.07.2024.
//

import UIKit

final class MainPageBalanceView: UIView {
 
    let yourBalanceLabel = UILabel()
    let accountBalanceLabel = UILabel()
    let balanceCurrencyLabel = UILabel()
    
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupViews()
        setupLayout()
    }
    
    private func setupViews() {
        yourBalanceLabel.text = "Your Balance"
        yourBalanceLabel.font = .sfProDisplay(ofSize: 14, weight: .regular)
        yourBalanceLabel.textColor = .white
        
        accountBalanceLabel.text = "0.00"
        accountBalanceLabel.font = .sfProDisplay(ofSize: 26, weight: .semibold)
        accountBalanceLabel.textColor = .white
        
        balanceCurrencyLabel.text = "BTC"
        balanceCurrencyLabel.font = .sfProDisplay(ofSize: 16, weight: .regular)
        balanceCurrencyLabel.textColor = .white
    }
    
    private func setupLayout() {
        yourBalanceLabel.translatesAutoresizingMaskIntoConstraints = false
        accountBalanceLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceCurrencyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(yourBalanceLabel)
        addSubview(accountBalanceLabel)
        addSubview(balanceCurrencyLabel)
        
        
        NSLayoutConstraint.activate([

            yourBalanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            yourBalanceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            yourBalanceLabel.topAnchor.constraint(equalTo: topAnchor),
            yourBalanceLabel.heightAnchor.constraint(equalToConstant: 30),

            accountBalanceLabel.topAnchor.constraint(equalTo: yourBalanceLabel.bottomAnchor),
            accountBalanceLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            accountBalanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            accountBalanceLabel.heightAnchor.constraint(equalToConstant: 24),
            
            balanceCurrencyLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            balanceCurrencyLabel.leadingAnchor.constraint(equalTo: accountBalanceLabel.trailingAnchor, constant: 4),
            balanceCurrencyLabel.heightAnchor.constraint(equalToConstant: 16),
            
        ])
        
    }
}
