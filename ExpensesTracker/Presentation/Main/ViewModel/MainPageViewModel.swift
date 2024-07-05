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

final class ExchangeRateModel {
    
    func getBtcUsdRate(completion: @escaping (Result<String, Error>) -> Void) {
        do {
            try Network<CurrentBitcoinPriceEndpoint>(APIHost.coindesk)
                .perform(.get, .currentBitcoinPrice) { result in
                    
                switch result {
                    case .data(let data):
                        guard let data,
                              let rates = try? JSONDecoder().decode(BitcoinPriceData.self, from: data)
                        else {
                            completion(.failure(NetworkError.decodingFailed))
                            return
                        }
                            
                        let usdRate = rates.bpi.USD.rate

                        completion(.success(usdRate))
                    case .error(let error):
                        completion(.failure(error))
                    }
                }
            
        } catch {
            print(error)
            completion(.failure(error))
        }
    }
    
}

final class MainPageViewModel {
    
    private let exchangeRateModel: ExchangeRateModel
    
    var bitcoinUsdRate: Double = 0
    
    init(exchangeRateModel: ExchangeRateModel) {
        self.exchangeRateModel = exchangeRateModel
        
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
