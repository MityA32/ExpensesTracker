//
//  MainPageViewController.swift
//  ExpensesTracker
//
//  Created by Dmytro Hetman on 04.07.2024.
//

import UIKit

final class MainPageViewController: BaseBackgroundUIViewController {

    private let exchangeRateView = ExchangeRateView()
    private let balanceView = MainPageBalanceView()
    private let manageBalanceView = MainPageManageBalanceButtonsView()
    private let transactionsHistoryView = TransactionsHistoryView()
    private let networkConnectionStatusLabel = UILabel()
    

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
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .networkStatusChanged, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupValues()
    }

    private func setup() {
        setupButtons()
        setupLayout()
        setupTransactionsTable()
        setupNetworkMonitor()
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
        updateBitcoinUsdRate()
        updateBalance()
        updateTransactions()
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
    
    private func updateBitcoinUsdRate() {
        viewModel.getBtcUsdRate { [weak self] rate in
            DispatchQueue.main.async {
                self?.exchangeRateView.setExchangeRateValue(rate)
            }
        }
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

extension MainPageViewController {
    
    private func setupNetworkMonitor() {
        setupNetworkStatusLabel()
        NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged), name: .networkStatusChanged, object: nil)
        
        if NetworkMonitor.checkInternetConnectivity() {
            networkDidBecomeAvailable()
        } else {
            networkDidBecomeUnavailable()
        }
    }
    
    @objc private func networkStatusChanged(notification: Notification) {
        if NetworkMonitor.checkInternetConnectivity() {
            networkDidBecomeAvailable()
        } else {
            networkDidBecomeUnavailable()
        }
    }
    
    private func networkDidBecomeAvailable() {
        DispatchQueue.main.async { [weak self] in
            self?.networkConnectionStatusLabel.isHidden = false
            self?.networkConnectionStatusLabel.text = "Connection is here!"
            
        }
        print("Network is available")
        updateBitcoinUsdRate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.networkConnectionStatusLabel.isHidden = true
        }
    }
    
    private func networkDidBecomeUnavailable() {
        DispatchQueue.main.async { [weak self] in
            self?.networkConnectionStatusLabel.text = "No internet connection..."
            self?.networkConnectionStatusLabel.isHidden = false
        }
        print("Network is unavailable")
    }
    
    private func setupNetworkStatusLabel() {
        networkConnectionStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(networkConnectionStatusLabel)
        
        NSLayoutConstraint.activate([
            networkConnectionStatusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            networkConnectionStatusLabel.centerYAnchor.constraint(equalTo: exchangeRateView.centerYAnchor)
        ])
        
        networkConnectionStatusLabel.font = .sfProDisplay(ofSize: 14, weight: .regular)
        networkConnectionStatusLabel.textColor = .white
        networkConnectionStatusLabel.isHidden = true
    }
}

extension MainPageViewController {
    private func setupTransactionsTable() {
        let tableView = transactionsHistoryView.tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TransactionsHistoryTableViewCell.self, forCellReuseIdentifier: TransactionsHistoryTableViewCell.id)
        tableView.rowHeight = 96
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false

        loadMoreTransactions()
    }
}

extension MainPageViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.groupedTransactions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.groupedTransactions[section].transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView
            .dequeueReusableCell(
                withIdentifier: TransactionsHistoryTableViewCell.id,
                for: indexPath
            ) as! TransactionsHistoryTableViewCell
        let transaction = viewModel.groupedTransactions[indexPath.section].transactions[indexPath.row]
        cell.config(from: transaction)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = viewModel.groupedTransactions[section].date
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            return dateFormatter.string(from: date)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == viewModel.groupedTransactions.count - 1 && indexPath.row == viewModel.groupedTransactions[indexPath.section].transactions.count - 1 {
            loadMoreTransactions()
        }
    }
    
    private func loadMoreTransactions() {
       viewModel.fetchMoreTransactions { [weak self] newTransactions in
           guard let self else { return }
           if !newTransactions.isEmpty {
               let tableView = transactionsHistoryView.tableView
               // for view like something loading
               DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                   tableView.reloadData()
               }
           }
       }
   }
}

extension MainPageViewController: AddTransactionDelegate {
    func didAddTransaction(value: String, category: Category) {
        viewModel.addExpenseTransaction(transactionValue: value, for: category) { result in
            switch result {
            case .success(_):
                updateBalance()
                updateTransactions()
                dismiss(animated: true)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
}
