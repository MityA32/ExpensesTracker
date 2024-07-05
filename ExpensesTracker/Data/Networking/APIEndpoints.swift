//
//  APIEndpoints.swift
//  ExpensesTracker
//
//  Created by Dmytro Hetman on 04.07.2024.
//

import Foundation

// https://api.coindesk.com/v1/bpi/currentprice.json

enum APIHost {
    static let coindesk = "https://api.coindesk.com/v1"
}

protocol Endpoint {
    
    var pathComponent: String { get }
    
}

enum CurrentBitcoinPriceEndpoint: String, Endpoint {
    
    case currentBitcoinPrice = "bpi/currentprice.json"
    
    var pathComponent: String {
        rawValue
    }
    
}
