//
//  PreviewData.swift
//  ExpenseTracker
//
//  Created by Guntars Reiss on 08/05/2023.
//

import Foundation
import SwiftUI

var transactionPreviewData = Transaction(id: 1, date: "03/11/2023", institution: "Desjardins", account: "Visa Desjardins", merchant: "Apple", amount: 11.49, type: "debit", categoryId: 801, category: "Software", isPending: false, isTransfer: false, isExpense: true, isEdited: false)

var transactionListPreviewData = [Transaction](repeating: transactionPreviewData, count: 10)
