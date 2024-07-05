//
//  EndpointsInstructions.swift
//  ExpensesTracker
//
//  Created by Dmytro Hetman on 04.07.2024.
//

import Foundation

protocol NetworkRequestBodyConvertible {
    
    var data: Data? { get }
    var queryItems: [URLQueryItem]? { get }
    var parameters: [String : Any]? { get }
    
}

struct CurrentBitcoinPriceInstruction: NetworkRequestBodyConvertible {
    
    var data: Data? { nil }
    var queryItems: [URLQueryItem]? { nil }
    var parameters: [String : Any]? { nil }
    
}
