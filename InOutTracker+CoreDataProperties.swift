//
//  InOutTracker+CoreDataProperties.swift
//  InOut Tracker
//
//  Created by Nives on 21.12.2024..
//
//

import Foundation
import CoreData


extension InOutTracker {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InOutTracker> {
        return NSFetchRequest<InOutTracker>(entityName: "InOutTrackerEntity")
    }

    @NSManaged public var timestamp: Date?
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var action: String?

}
