//
//  ViewController.swift
//  ExpensesTracker
//
//  Created by Dmytro Hetman on 04.07.2024.
//

import UIKit

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupValues()
    }

    private func setup() {
        setupButtons()
        setupLayout()
        setupTransactionsTable()
    }
    
    private func setupButtons() {
        manageBalanceView.topUpBalanceButton.addTarget(self, action: #selector(showAddBitcoinPopUp), for: .touchUpInside)
        manageBalanceView.addTransactionButton.addTarget(self, action: #selector(showAddTransactionScreen), for: .touchUpInside)
    }
    
    @objc func showAddTransactionScreen() {
        guard let user = viewModel.users.first else { return }
        let addTransactionVC = AddTransactionViewController(viewModel: AddTransactionViewModel())
        addTransactionVC.delegate = self
        addTransactionVC.modalPresentationStyle = .overFullScreen
        navigationController?.present(addTransactionVC, animated: true)
    }
    
    
    @objc func showAddBitcoinPopUp() {
        let alertController = UIAlertController(title: "Add Bitcoins", message: "Enter the amount of bitcoins", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Amount"
            textField.keyboardType = .decimalPad
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let textField = alertController.textFields?.first,
                  let text = textField.text
            else { return }
            
            self?.addBitcoins(text)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    func addBitcoins(_ amount: String) {

        viewModel.topUpBalance(on: amount) {
            balanceView.accountBalanceLabel.text = $0
        }
        
        updateTransactions()
    }
    
    private func setupValues() {
        viewModel.getBtcUsdRate { [weak self] rate in
            DispatchQueue.main.async {
                self?.exchangeRateView.setExchangeRateValue(rate)
            }
        }
        
        updateBalance()
        
        viewModel.userHasTransactions { hasTransactions in
            transactionsHistoryView.noTransactionsLabel.isHidden = hasTransactions
            transactionsHistoryView.tableView.isHidden = !hasTransactions
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
    
    private func updateBalance() {
        viewModel.configureBalance { balance in
            balanceView.accountBalanceLabel.text = balance
        }
    }
    
    private func updateTransactions() {
        viewModel.userHasTransactions { hasTransactions in
            transactionsHistoryView.noTransactionsLabel.isHidden = hasTransactions
            transactionsHistoryView.tableView.isHidden = !hasTransactions
            transactionsHistoryView.tableView.reloadData()
        }
    }

}

extension ViewController {
    private func setupTransactionsTable() {
        let tableView = transactionsHistoryView.tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 40
        
    }
}

extension ViewController: UITableViewDelegate {

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = viewModel.transactions[indexPath.row].type ?? "unknown"
        return cell
    }
}

extension ViewController: AddTransactionDelegate {
    func didAddTransaction(value: String, category: Category) {
        viewModel.addExpenseTransaction(transactionValue: value, for: category) { result in
            switch result {
            case .success(let success):
                updateBalance()
                updateTransactions()
                dismiss(animated: true)
            case .failure(let failure):
                print(failure)
//                showInsufficientFundsAlert()
            }
        }
    }
    
    func didAddTransaction() {
        print("-")
        
        
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
    
   
}
