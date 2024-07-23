//
//  BtcRate+CoreDataProperties.swift
//  ExpenseTracker
//
//  Created by Viktor Sovyak on 7/23/24.
//
//

import Foundation
import CoreData


extension BtcRate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BtcRate> {
        return NSFetchRequest<BtcRate>(entityName: "BtcRate")
    }

    @NSManaged public var lastUpdated: Date?
    @NSManaged public var rate: Float

}

extension BtcRate : Identifiable {

}
