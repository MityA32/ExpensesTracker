//
//  Date+Extension.swift
//  ExpensesTracker
//
//  Created by Dmytro Hetman on 06.07.2024.
//

import Foundation

extension Date {
    func hasOneHourPassed() -> Bool {
        guard let oneHourAgo = Calendar.current.date(byAdding: .hour, value: -1, to: Date()) else {
            return false
        }
        
        return self < oneHourAgo
    }
}
