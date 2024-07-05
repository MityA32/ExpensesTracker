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
        
        addSubview(mainLabel)
        addSubview(noTransactionsLabel)
        
        NSLayoutConstraint.activate([

            mainLabel.topAnchor.constraint(equalTo: topAnchor),
            mainLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainLabel.heightAnchor.constraint(equalToConstant: 28),

            noTransactionsLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 100),
            noTransactionsLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            noTransactionsLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

        ])
    }
}

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

final class ViewController: BaseBackgroundUIViewController {
    
    private let exchangeRateView = ExchangeRateView()
    private let balanceView = MainPageBalanceView()
    private let manageBalanceView = MainPageManageBalanceButtonsView()
    private let transactionsHistoryView = TransactionsHistoryView()
    
    
    let viewModel: MainPageViewModel
    
    init(viewModel: MainPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    private func setup() {
        setupValues()
        setupLayout()
    }
    
    private func setupValues() {
        viewModel.getBtcUsdRate { [weak self] rate in
            DispatchQueue.main.async {
                self?.exchangeRateView.setExchangeRateValue(rate)
            }
        }
    }
    
    private func setupLayout() {
        balanceView.translatesAutoresizingMaskIntoConstraints = false
        manageBalanceView.translatesAutoresizingMaskIntoConstraints = false
        transactionsHistoryView.translatesAutoresizingMaskIntoConstraints = false
        exchangeRateView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(exchangeRateView)
        view.addSubview(balanceView)
        view.addSubview(manageBalanceView)
        view.addSubview(transactionsHistoryView)
        
        NSLayoutConstraint.activate([
            exchangeRateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            exchangeRateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            exchangeRateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            exchangeRateView.heightAnchor.constraint(equalToConstant: 44),
        
            balanceView.topAnchor.constraint(equalTo: exchangeRateView.bottomAnchor, constant: 12),
            balanceView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            balanceView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            balanceView.heightAnchor.constraint(equalToConstant: 54),

            manageBalanceView.topAnchor.constraint(equalTo: balanceView.bottomAnchor, constant: 16),
            manageBalanceView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            manageBalanceView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            manageBalanceView.heightAnchor.constraint(equalToConstant: 30),
            
            transactionsHistoryView.topAnchor.constraint(equalTo: manageBalanceView.bottomAnchor, constant: 32),
            transactionsHistoryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            transactionsHistoryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            transactionsHistoryView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        ])
    }

}
