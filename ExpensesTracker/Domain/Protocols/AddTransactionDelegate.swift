//
//  AddTransactionDelegate.swift
//  ExpensesTracker
//
//  Created by Dmytro Hetman on 08.07.2024.
//

import Foundation

protocol AddTransactionDelegate: AnyObject {
    func didAddTransaction(value: String, category: Category)
    func dismiss()
}
