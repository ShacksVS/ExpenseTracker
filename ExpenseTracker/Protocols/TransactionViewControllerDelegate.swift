//
//  TransactionViewControllerDelegate.swift
//  ExpenseTracker
//
//  Created by Viktor Sovyak on 7/23/24.
//

import Foundation

protocol TransactionViewControllerDelegate: AnyObject {
    func didAddTransaction(_ transaction: Transaction)
}
