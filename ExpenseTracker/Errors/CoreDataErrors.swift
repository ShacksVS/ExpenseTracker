//
//  CoreDataErrors.swift
//  ExpenseTracker
//
//  Created by Viktor Sovyak on 7/23/24.
//

import Foundation

enum CoreDataErrors: Error {
    case failedToFetchTransactions
    case failedToSave
}
