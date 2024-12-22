//
//  AppUser+CoreDataProperties.swift
//  InOut Tracker
//
//  Created by Nives on 21.12.2024..
//
//

import Foundation
import CoreData


extension AppUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppUser> {
        return NSFetchRequest<AppUser>(entityName: "AppUserEntity")
    }

    @NSManaged public var password: String?
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var biometricRegistered: Bool

}

extension AppUser : Identifiable {

}
