//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Guntars Reiss on 08/05/2023.
//

import SwiftUI
import SwiftUICharts

struct ContentView: View {
    @EnvironmentObject var transactionListVM: TransactionListVM
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // MARK: Title
                    Text("Overview")
                        .font(.title2)
                        .bold()
                    
                    // MARK: Chart
                    let data = transactionListVM.accumulateTransactions()
                    
                    if !data.isEmpty {
                        let totalExpenses = data.last?.1 ?? 0
                        
                        CardView(showShadow: false) {
                            VStack(alignment: .leading) {
                                ChartLabel(totalExpenses.formatted(.currency(code: "EUR")), type: .title, format: "%.02f €")
                                    
                                LineChart()
                                    
                            }
                            .background(Color.systemBackground)
                        }
                        .data(data)
                        .chartStyle(ChartStyle(backgroundColor: Color.systemBackground, foregroundColor: ColorGradient(Color.icon.opacity(0.4), Color.icon)))
                        .frame(height: 300)
                        .cornerRadius(20)
                        .shadow(color: Color.primary.opacity(0.2), radius: 10, x: 0, y: 5)
                    }
                    
                    // MARK: Transaction List
                    RecentTransactionList()
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .background(Color.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // MARK: Notification Icon
                ToolbarItem {
                    Image(systemName: "bell.badge")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.icon, .primary)
                }
            }
        }
        .navigationViewStyle(.stack)
        // Edit back button's color (you can use custom colors as well)
        .tint(.primary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static let transactionListVM: TransactionListVM = {
        let transactionListVM = TransactionListVM()
        transactionListVM.transactions = transactionListPreviewData
        return transactionListVM
    }()
    
    static var previews: some View {
        ContentView()
            .environmentObject(transactionListVM)
    }
}
