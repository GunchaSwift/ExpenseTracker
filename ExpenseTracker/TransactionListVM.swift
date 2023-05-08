//
//  TransactionListVM.swift
//  ExpenseTracker
//
//  Created by Guntars Reiss on 08/05/2023.
//

import Foundation
import SwiftUI

final class TransactionListVM: ObservableObject {
    @Published var transactions: [Transaction] = []
    
    init() {
        Task {
            await getTransactions()
            print("Get transactions method called.")
        }
    }
    
    func getTransactions() async {
        guard let url = URL(string: "https://designcode.io/data/transactions.json") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode([Transaction].self, from: data)
            
            DispatchQueue.main.async {
                self.transactions = decodedData
                print("Data decoded.")
            }
        } catch {
            print("Error creating URLSession from URL")
            return
        }

    }
}
