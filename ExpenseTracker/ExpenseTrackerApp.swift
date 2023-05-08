//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Guntars Reiss on 08/05/2023.
//

import SwiftUI

@main
struct ExpenseTrackerApp: App {
    @StateObject var transactionListVM = TransactionListVM()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(transactionListVM)
        }
    }
}
