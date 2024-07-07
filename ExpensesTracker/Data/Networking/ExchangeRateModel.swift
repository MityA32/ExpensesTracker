//
//  ExchangeRateModel.swift
//  ExpensesTracker
//
//  Created by Dmytro Hetman on 06.07.2024.
//

import Foundation

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
