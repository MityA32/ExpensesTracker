//
//  AddTransactionViewModel.swift
//  ExpensesTracker
//
//  Created by Dmytro Hetman on 07.07.2024.
//

import Foundation

final class AddTransactionViewModel {

    let categories: [Category] = [.groceries, .taxi, .electronics, .restaurant, .other]
    @Fetch var users: [User]
    
    func checkTransactionPossibility(transactionValue: String, completion: (Bool) -> Void) {
        guard let user = users.first else { return }
        if let transactionValue = Double(transactionValue.replacingOccurrences(of: ",", with: ".")) {
            completion(user.balance > transactionValue)
        } else {
            completion(false)
        }
    }
    
}
