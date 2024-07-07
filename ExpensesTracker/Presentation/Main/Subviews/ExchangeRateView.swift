//
//  ExchangeRateView.swift
//  ExpensesTracker
//
//  Created by Dmytro Hetman on 06.07.2024.
//

import UIKit

final class ExchangeRateView: UIView {
    
    private let currencyRatioLabel = UILabel()
    private let exchangeRateValueLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setExchangeRateValue(_ rate: String) {
        exchangeRateValueLabel.text = rate
    }
    
    private func setup() {
        setupLayout()
        setupViews()
    }
    
    private func setupViews() {
        currencyRatioLabel.text = "BTC/USD"
        currencyRatioLabel.textAlignment = .center
        currencyRatioLabel.textColor = .white
        currencyRatioLabel.font = .sfProDisplay(ofSize: 16, weight: .regular)
        currencyRatioLabel.layer.backgroundColor = UIColor.gray.cgColor
        currencyRatioLabel.layer.cornerRadius = 4
        
        exchangeRateValueLabel.textColor = .white
        exchangeRateValueLabel.font = .sfProDisplay(ofSize: 20, weight: .semibold)
    }
    
    private func setupLayout() {
        currencyRatioLabel.translatesAutoresizingMaskIntoConstraints = false
        exchangeRateValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(currencyRatioLabel)
        addSubview(exchangeRateValueLabel)
        
        NSLayoutConstraint.activate([
            exchangeRateValueLabel.topAnchor.constraint(equalTo: topAnchor),
            exchangeRateValueLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            exchangeRateValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            currencyRatioLabel.trailingAnchor.constraint(equalTo: exchangeRateValueLabel.leadingAnchor, constant: -8),
            currencyRatioLabel.heightAnchor.constraint(equalToConstant: 28),
            currencyRatioLabel.widthAnchor.constraint(equalToConstant: 72),
            currencyRatioLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}
