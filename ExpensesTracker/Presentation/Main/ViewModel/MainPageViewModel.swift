//
//  MainPageViewModel.swift
//  ExpensesTracker
//
//  Created by Dmytro Hetman on 05.07.2024.
//

import Foundation


enum NetworkError: Error {
    case decodingFailed
}

enum TransactionError: Error {
    case insufficientFunds

}

final class MainPageViewModel {
    
    private let exchangeRateModel: ExchangeRateModel
    private let coredataService: CoreDataService
    
    @Fetch var users: [User]
    var bitcoinBalance: Double = 0
    var transactions: [Transaction] = []
    
    
    
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
        if let topUpValue = Double(amount.replacingOccurrences(of: ",", with: ".")) {
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
            bitcoinBalance += topUpValue
            completion(String(format: "%g", bitcoinBalance))

        }
    }
    
    func addExpenseTransaction(transactionValue: String, for category: Category, completion: (Result<String, TransactionError>) -> Void) {
        if let transactionValue = Double(transactionValue.replacingOccurrences(of: ",", with: ".")) {
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
                bitcoinBalance -= transactionValue
                completion(.success(String(format: "%g", bitcoinBalance)))
            }
        }
    }
    
    func getBtcUsdRate(completion: @escaping (String) -> Void) {
        guard let user = users.first else { return }
        if user.exchangeRateLastTimeUpdated?.hasOneHourPassed() == true || user.bitcoinUsdExchangeRate == nil  {
            print(user.exchangeRateLastTimeUpdated?.formatted())
            exchangeRateModel.getBtcUsdRate { [weak self] in
                switch $0 {
                case .success(let rate):
                    self?.coredataService.performWrite { context in
                        user.bitcoinUsdExchangeRate = rate
                        user.exchangeRateLastTimeUpdated = Date()
                    }
                    completion(rate)
                case .failure(_):
                    completion(user.bitcoinUsdExchangeRate ?? "--")
                }
            }
        } else {
            completion(user.bitcoinUsdExchangeRate ?? "--")
        }
    }
    
    func configureBalance(completion: (String) -> Void) {
        completion(String(format: "%g", bitcoinBalance))
    }
    
    func userHasTransactions(completion: (Bool) -> Void) {
        completion(!transactions.isEmpty)
    }
    
}
