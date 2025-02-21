//
//  MainPageViewModel.swift
//  ExpensesTracker
//
//  Created by Dmytro Hetman on 05.07.2024.
//

import Foundation

final class MainPageViewModel {
    
    private let exchangeRateModel: ExchangeRateModel
    private let coredataService: CoreDataService
    
    @Fetch var users: [User]
    var bitcoinBalance: Double = 0
    var transactions: [Transaction] = []
    var currentPage = 0
    let pageSize = 20
    
    var groupedTransactions: [(date: Date, transactions: [Transaction])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: transactions) { (transaction) -> Date in
            return calendar.startOfDay(for: transaction.timeCreated ?? Date())
        }
        
        return grouped.keys.sorted(by: >).map { (date) -> (date: Date, transactions: [Transaction]) in
            return (date: date, transactions: grouped[date]!)
        }
    }
    
    init(exchangeRateModel: ExchangeRateModel, coredataService: CoreDataService) {
        self.exchangeRateModel = exchangeRateModel
        self.coredataService = coredataService
        configureUserInfo()
    }
    
    private func configureUserInfo() {
        if users.isEmpty {
            createUser()
        } else {
            guard let user = users.first else { return }
            
            bitcoinBalance = user.balance
            
            guard let transactions = user.transactions?.allObjects as? [Transaction] else { return }
            self.transactions.append(contentsOf: transactions)
            self.transactions = self.transactions.sorted(by: { $0.timeCreated ?? Date() > $1.timeCreated ?? Date()})
            
            print(bitcoinBalance)
        }
    }
    
    private func createUser() {
        coredataService.performWrite { [weak self] context in
            self?.coredataService.create(User.self) { user in
                user.id = UUID()
                user.balance = 0
                user.bitcoinUsdExchangeRate = nil
                user.exchangeRateLastTimeUpdated = nil
                user.transactions = []
            }
        }
    }
    
    func topUpBalance(on amount: String, completion: (String) -> Void) {
        guard let topUpValue = Double(amount.replacingOccurrences(of: ",", with: "."))
        else { return }
        coredataService.performWrite { [weak self] context in
            guard let user = self?.users.first else { return }
            user.balance += topUpValue

            self?.coredataService.create(Transaction.self) { transaction in
                transaction.id = UUID()
                transaction.amount = topUpValue
                transaction.timeCreated = Date()
                transaction.type = TransactionType.incoming.rawValue
                transaction.user = user

                self?.transactions.insert(transaction, at: 0)
            }
        }
        let decimalBitcoinBalance = Decimal(bitcoinBalance)
        let decimalTransactionValue = Decimal(topUpValue)

        bitcoinBalance = NSDecimalNumber(decimal: decimalBitcoinBalance + decimalTransactionValue).doubleValue
        completion(NSDecimalNumber(decimal: Decimal(bitcoinBalance)).stringValue)
    }
    
    func addExpenseTransaction(transactionValue: String, for category: Category, completion: (Result<String, TransactionError>) -> Void) {
        guard let transactionValue = Double(transactionValue.replacingOccurrences(of: ",", with: ".")) else { return }
        
        if bitcoinBalance < transactionValue {
            completion(.failure(TransactionError.insufficientFunds))
        } else {
            coredataService.performWrite { [weak self] context in
                guard let user = self?.users.first else { return }
                user.balance -= transactionValue
                self?.coredataService.create(Transaction.self) { transaction in
                    transaction.id = UUID()
                    transaction.amount = transactionValue
                    transaction.timeCreated = Date()
                    transaction.category = category.rawValue
                    transaction.type = TransactionType.outgoing.rawValue
                    transaction.user = user
                    self?.transactions.insert(transaction, at: 0)
                }
            }
            let decimalBitcoinBalance = Decimal(bitcoinBalance)
            let decimalTransactionValue = Decimal(transactionValue)

            bitcoinBalance = NSDecimalNumber(decimal: decimalBitcoinBalance - decimalTransactionValue).doubleValue
            completion(.success(NSDecimalNumber(decimal: Decimal(bitcoinBalance)).stringValue))
        }
    }
    
    func getBtcUsdRate(completion: @escaping (String) -> Void) {
        guard let user = users.first else { return }
        if user.exchangeRateLastTimeUpdated?.hasOneHourPassed() == true || user.bitcoinUsdExchangeRate == nil  {
            print(user.exchangeRateLastTimeUpdated?.formatted())
            exchangeRateModel.getBtcUsdRate { [weak self] in
                switch $0 {
                case .success(let rate):
                    print("newly loading exchage rate")
                    self?.coredataService.performWrite { context in
                        user.bitcoinUsdExchangeRate = rate
                        user.exchangeRateLastTimeUpdated = Date()
                    }
                    completion(rate)
                case .failure(_):
                    print("failed loading exchage rate")
                    completion(user.bitcoinUsdExchangeRate ?? "--")
                }
            }
        } else {
            print("loaded from db \(user.bitcoinUsdExchangeRate)")
            print("last time updated \(user.exchangeRateLastTimeUpdated)")
            completion(user.bitcoinUsdExchangeRate ?? "--")
        }
    }
    
    func configureBalance(completion: (String) -> Void) {
        completion(NSDecimalNumber(decimal: Decimal(bitcoinBalance)).stringValue)
    }
    
    func userHasTransactions(completion: (Bool) -> Void) {
        completion(!transactions.isEmpty)
    }
    
    func fetchMoreTransactions(completion: ([Transaction]) -> Void) {
        guard let user = users.first else { return }
        
        let allTransactions = (user.transactions?.allObjects as? [Transaction])?.sorted(by: { $0.timeCreated ?? Date() > $1.timeCreated ?? Date() }) ?? []
        
        let startIndex = currentPage * pageSize
        let endIndex = min(startIndex + pageSize, allTransactions.count)
        
        if startIndex < endIndex {
            let newTransactions = Array(allTransactions[startIndex..<endIndex])
            self.transactions.append(contentsOf: newTransactions)
            currentPage += 1
            completion(newTransactions)
        } else {
            completion([])
        }
    }
}
