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
            guard let user = user() else { return }
            
            bitcoinBalance = user.balance
            guard let transactions = user.transactions?.allObjects as? [Transaction] else { return }
            self.transactions.append(contentsOf: transactions)
            
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
            bitcoinBalance += topUpValue
            completion("\(bitcoinBalance)")
        }
    }
    
    func getBtcUsdRate(completion: @escaping (String) -> Void) {
        guard let user = user() else { return }
        if user.exchangeRateLastTimeUpdated?.hasOneHourPassed() == true || user.exchangeRateLastTimeUpdated == nil  {
            exchangeRateModel.getBtcUsdRate { [weak self] in
                switch $0 {
                case .success(let rate):
                    self?.coredataService.performWrite { context in
                        guard let user = self?.user() else { return }
                        user.bitcoinUsdExchangeRate = rate
                        user.exchangeRateLastTimeUpdated = Date()
                    }
                    completion(rate)
                case .failure(_):
                    completion("--")
                }
            }
        } else {
            completion(user.bitcoinUsdExchangeRate ?? "--")
        }
    }
    
    private func user() -> User? {
        guard users.count == 1,
            let user = users.first
        else { return nil }
        return user
    }
    
    
}
