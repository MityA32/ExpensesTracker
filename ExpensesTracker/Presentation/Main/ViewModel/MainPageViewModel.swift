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
    
    var bitcoinBalance: Double = 0
    var transactions: [Transaction] = []
    
    init(exchangeRateModel: ExchangeRateModel) {
        self.exchangeRateModel = exchangeRateModel
        
    }
    
    func topUpBalance(on amount: String, completion: (String) -> Void) {
        if let topUpValue = Double(amount.replacingOccurrences(of: ",", with: ".")) {
            bitcoinBalance += topUpValue
            completion("\(bitcoinBalance)")
        }
    }
    
    func getBtcUsdRate(completion: @escaping (String) -> Void) {
        exchangeRateModel.getBtcUsdRate {
            switch $0 {
                case .success(let rate):
                    completion(rate)
                case .failure(_):
                    completion("--")
            }
        }
    }
    
    
}
