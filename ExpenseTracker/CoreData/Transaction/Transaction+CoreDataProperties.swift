//
//  Transaction+CoreDataProperties.swift
//  ExpenseTracker
//
//  Created by Viktor Sovyak on 7/23/24.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        let request = NSFetchRequest<Transaction>(entityName: "Transaction")
        let sortDescriptor = NSSortDescriptor(key: "transactionDate", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        return request
    }

    @NSManaged public var transactionDate: Date?
    @NSManaged public var amount: Float
    @NSManaged public var category: String?

}

extension Transaction : Identifiable {

}
