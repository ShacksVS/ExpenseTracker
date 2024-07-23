//
//  Balance+CoreDataProperties.swift
//  ExpenseTracker
//
//  Created by Viktor Sovyak on 7/23/24.
//
//

import Foundation
import CoreData


extension Balance {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Balance> {
        return NSFetchRequest<Balance>(entityName: "Balance")
    }

    @NSManaged public var amountBTC: Float

}

extension Balance : Identifiable {

}
