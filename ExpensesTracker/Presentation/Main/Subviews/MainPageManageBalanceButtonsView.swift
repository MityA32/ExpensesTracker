//
//  MainPageManageBalanceButtonsView.swift
//  ExpensesTracker
//
//  Created by Dmytro Hetman on 06.07.2024.
//

import UIKit

final class MainPageManageBalanceButtonsView: UIView {
    
    let topUpBalanceButton = UIButton()
    let addTransactionButton = UIButton()
    private let buttonsStackView = UIStackView()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupLayout()
        setupViews()
    }
    
    private func setupViews() {
        topUpBalanceButton.backgroundColor = .purple
        topUpBalanceButton.layer.cornerRadius = 4
        topUpBalanceButton.setTitle("Top up", for: .normal)
        topUpBalanceButton.setTitleColor(.white, for: .normal)
        topUpBalanceButton.titleLabel?.font = .sfProDisplay(ofSize: 14, weight: .medium)
        
        
        addTransactionButton.backgroundColor = .gray
        addTransactionButton.layer.cornerRadius = 4
        addTransactionButton.setTitle("Add Transaction", for: .normal)
        addTransactionButton.setTitleColor(.white, for: .normal)
        addTransactionButton.titleLabel?.font = .sfProDisplay(ofSize: 14, weight: .medium)
    }
    
    private func setupLayout() {
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            buttonsStackView.topAnchor.constraint(equalTo: topAnchor),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 8
        buttonsStackView.distribution = .fillEqually
        
        buttonsStackView.addArrangedSubview(topUpBalanceButton)
        buttonsStackView.addArrangedSubview(addTransactionButton)
        
    }
    
}
