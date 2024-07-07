//
//  TransactionsHistoryTableViewCell.swift
//  ExpensesTracker
//
//  Created by Dmytro Hetman on 07.07.2024.
//

import UIKit

final class TransactionsHistoryTableViewCell: UITableViewCell {
    
    static let id = "\(TransactionsHistoryTableViewCell.self)"

    private let customBackgroundView = UIView()
    private let transactionValue = UILabel()
    private let transactionCategory = UILabel()
    private let transactionDate = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        transactionValue.text = ""
        transactionCategory.text = ""
        transactionDate.text = ""
    }
    
    private func setup() {
        backgroundColor = .clear
        
        transactionValue.font = .sfProDisplay(ofSize: 18, weight: .bold)
        transactionCategory.font = .sfProDisplay(ofSize: 16, weight: .regular)
        transactionDate.font = .sfProDisplay(ofSize: 16, weight: .medium)
        
        customBackgroundView.backgroundColor = .darkGray
        customBackgroundView.layer.cornerRadius = 16
        
        transactionCategory.textColor = .white
        transactionDate.textColor = .white

        customBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        transactionValue.translatesAutoresizingMaskIntoConstraints = false
        transactionCategory.translatesAutoresizingMaskIntoConstraints = false
        transactionDate.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(customBackgroundView)
        customBackgroundView.addSubview(transactionValue)
        customBackgroundView.addSubview(transactionCategory)
        customBackgroundView.addSubview(transactionDate)
        
        NSLayoutConstraint.activate([
            customBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            customBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            customBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            customBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            
            transactionValue.topAnchor.constraint(equalTo: customBackgroundView.topAnchor, constant: 16),
            transactionValue.leadingAnchor.constraint(equalTo: customBackgroundView.leadingAnchor, constant: 16),
            
            transactionCategory.bottomAnchor.constraint(equalTo: customBackgroundView.bottomAnchor, constant: -8),
            transactionCategory.centerXAnchor.constraint(equalTo: customBackgroundView.centerXAnchor),
            
            transactionDate.topAnchor.constraint(equalTo: customBackgroundView.topAnchor, constant: 16),
            transactionDate.trailingAnchor.constraint(equalTo: customBackgroundView.trailingAnchor, constant: -16),

        ])
    }
    
    func config(from model: Transaction) {
        
        guard let modelType = model.type,
            let type = TransactionType(rawValue: modelType),
            let date = model.timeCreated?.formatted()
        else { return }
        switch type {
        case .incoming:
            transactionValue.text = String(format: "%g", model.amount) + " BTC"
            transactionValue.textColor = .systemGreen
            
            
        case .outgoing:
            transactionValue.text = "-" + String(format: "%g", model.amount) + " BTC"
            transactionValue.textColor = .white
            transactionCategory.text = "Category: " + (model.category?.capitalized ?? "unknown")
        }
        
        transactionDate.text = date
    }

}
