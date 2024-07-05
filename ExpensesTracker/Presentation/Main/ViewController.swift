//
//  ViewController.swift
//  ExpensesTracker
//
//  Created by Dmytro Hetman on 04.07.2024.
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
        
        accountBalanceLabel.text = "00.00"
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

            accountBalanceLabel.topAnchor.constraint(equalTo: yourBalanceLabel.bottomAnchor, constant: 0),
            accountBalanceLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            accountBalanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            accountBalanceLabel.heightAnchor.constraint(equalToConstant: 24),
            
            balanceCurrencyLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            balanceCurrencyLabel.leadingAnchor.constraint(equalTo: accountBalanceLabel.trailingAnchor, constant: 4),
            balanceCurrencyLabel.heightAnchor.constraint(equalToConstant: 16),
            
        ])
        
    }
}

final class MainPageManageBalanceButtonsView: UIView {
    
    let topUpBalanceButton = UIButton()
    let addTransactionButton = UIButton()
    let buttonsStackView = UIStackView()
    
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

final class ViewController: BaseBackgroundUIViewController {
    
    
    
    let balanceView = MainPageBalanceView()
    let manageBalanceView = MainPageManageBalanceButtonsView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }

    private func setup() {
        setupLayout()
    }
    
    private func setupLayout() {
        balanceView.translatesAutoresizingMaskIntoConstraints = false
        manageBalanceView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(balanceView)
        view.addSubview(manageBalanceView)
        
        NSLayoutConstraint.activate([
        
            balanceView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            balanceView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            balanceView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            manageBalanceView.topAnchor.constraint(equalTo: balanceView.bottomAnchor, constant: 16),
            manageBalanceView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            manageBalanceView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
        ])
    }

}

