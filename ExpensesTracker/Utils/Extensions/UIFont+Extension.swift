//
//  UIFont+Extension.swift
//  ExpensesTracker
//
//  Created by Dmytro Hetman on 04.07.2024.
//

import UIKit

extension UIFont {
    static func sfProDisplay(ofSize size: CGFloat, weight: CustomFontWeight) -> UIFont? {
        UIFont(name: "SFProDisplay\(weight.rawValue)", size: size)
    }
    
    enum CustomFontWeight: String {
        case bold = "-Bold"
        case medium = "-Medium"
        case regular = "-Regular"
        case semibold = "-Semibold"
    }
}
