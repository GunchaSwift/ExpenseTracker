//
//  Extensions.swift
//  ExpenseTracker
//
//  Created by Guntars Reiss on 08/05/2023.
//

import Foundation
import SwiftUI

extension Color {
    static let background = Color("Background")
    static let icon = Color("Icon")
    static let text = Color("Text")
    static let systemBackground = Color(uiColor: .systemBackground)
}

extension DateFormatter {
    // Lazy function, makes sure we initialize DateFormatter only once, static makes sure there is only one instance of it.
    static let normalNumericEU: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        return formatter
    }()
}

extension String {
    // Parse date
    func dateParsed() -> Date {
        guard let parsedDate = DateFormatter.normalNumericEU.date(from: self) else { return Date() }
        
        return parsedDate
    }
}
