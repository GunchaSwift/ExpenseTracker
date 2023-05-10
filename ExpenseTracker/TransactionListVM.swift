//
//  TransactionListVM.swift
//  ExpenseTracker
//
//  Created by Guntars Reiss on 08/05/2023.
//

import Foundation
import SwiftUI
// Add package "Apple Collections" to import this one
import Collections

// Typealias to be used for transaction grouping by month
// typealias TransactionGroup = [String: [Transaction]] returns dictionary, but dictionary is unorder
// This option returns ordered dictionary, new update in xcode 13
typealias TransactionGroup = OrderedDictionary<String, [Transaction]>
typealias TransactionPrefixSum = [(String, Double)]

final class TransactionListVM: ObservableObject {
    @Published var transactions: [Transaction] = []
    
    // call getTransactions when TransactionListVM is initialized
    init() {
        Task {
            await getTransactions()
            print("Get transactions method called.")
        }
    }
    
    // Get transactions from URL
    func getTransactions() async {
        // Make sure URL is correct
        guard let url = URL(string: "https://designcode.io/data/transactions.json") else {
            print("Invalid URL")
            return
        }
        
        // Using URLSession, decode data from URL
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode([Transaction].self, from: data)
            print("Decoded data:", decodedData)
            
            DispatchQueue.main.async {
                // All good, set transactions
                self.transactions = decodedData
                print("Data decoded.")
            }
        } catch {
            // Error
            print("Error creating URLSession from URL")
            return
        }

    }
    
    func groupTransactionsByMonth() -> TransactionGroup {
        // Make sure that there are transactions
        guard !transactions.isEmpty else { return [:] }
        
        // Group them by month
        let groupedTransactions = TransactionGroup(grouping: transactions) { $0.month }
        
        // Return dictionary
        return groupedTransactions
    }
    
    func accumulateTransactions() -> TransactionPrefixSum {
        print("Accumulate Transactions")
        guard !transactions.isEmpty else { return [] }
        
        let today = "02/17/2022".dateParsed() // For production use Date() to show today
        let dateInterval = Calendar.current.dateInterval(of: .month, for: today)!
        print("Date Interval", dateInterval)
        
        var sum: Double = .zero
        var cumulativeSum = TransactionPrefixSum()
        print("Sum:", sum, "cumulativeSum:", cumulativeSum)
        
        for date in stride(from: dateInterval.start, to: today, by: 60 * 60 * 24) {
            let dailyExpenses = transactions.filter { $0.dateParsed == date && $0.isExpense }
            let dailyTotal = dailyExpenses.reduce(0) { $0 - $1.signedAmount }
            
            sum += dailyTotal
            sum = sum.roundToTwoDigits()
            cumulativeSum.append((date.formatted(), sum))
            print(date.formatted(), "Daily total:", dailyTotal, "Sum:", sum)
        }
        
        // Standard for in doesn't work, because our dateInterval includes seconds, minutes and hours, so we must use stride
        /*for date in stride(from: dateInterval.start, to: today, by: 60 * 60 * 24) {
            let dailyExpenses = transactions.filter { $0.dateParsed == date && $0.isExpense }
            let dailyTotal = dailyExpenses.reduce(0) { $0 - $1.signedAmount }
            
            sum += dailyTotal
            cumulativeSum.append((date.formatted(), sum))
            print(date.formatted(), "Daily total:", dailyTotal, "sum:", sum)
        }*/
        
        
        return cumulativeSum
    }
}
