//
//  TransactionsHistoryView.swift
//  ExpensesTracker
//
//  Created by Dmytro Hetman on 06.07.2024.
//

import UIKit

final class TransactionsHistoryView: UIView {
    
    let mainLabel = UILabel()
    let noTransactionsLabel = UILabel()
    let tableView = UITableView()
    
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
        
        mainLabel.text = "Transaction History"
        mainLabel.font = .sfProDisplay(ofSize: 18, weight: .medium)
        mainLabel.textColor = .white
        mainLabel.textAlignment = .center
        
        noTransactionsLabel.text = "No transactions yet"
        noTransactionsLabel.font = .sfProDisplay(ofSize: 14, weight: .regular)
        noTransactionsLabel.textColor = .white
        noTransactionsLabel.textAlignment = .center
    }
    
    private func setupLayout() {
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        noTransactionsLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainLabel)
        addSubview(noTransactionsLabel)
        addSubview(tableView)
        
        NSLayoutConstraint.activate([

            mainLabel.topAnchor.constraint(equalTo: topAnchor),
            mainLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainLabel.heightAnchor.constraint(equalToConstant: 28),

            noTransactionsLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 100),
            noTransactionsLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            noTransactionsLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 32),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

        ])
    }
}
