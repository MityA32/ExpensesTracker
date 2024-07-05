//
//  CurrentBitcoinPriceResponse+Mapping.swift
//  ExpensesTracker
//
//  Created by Dmytro Hetman on 05.07.2024.
//

import Foundation

struct BitcoinPriceData: Codable {
    let time: Time
    let disclaimer: String
    let chartName: String
    let bpi: Bpi

    struct Time: Codable {
        let updated: String
        let updatedISO: String
        let updateduk: String
    }

    struct Bpi: Codable {
        let USD: Currency
        let GBP: Currency
        let EUR: Currency
    }

    struct Currency: Codable {
        let code: String
        let symbol: String
        let rate: String
        let description: String

    }
}
