//
//  UserManager.swift
//  InOut Tracker
//
//  Created by Nives on 21.12.2024..
//

import Foundation
import CoreData

class UserManager {
    static let shared = UserManager()
    private let context = PersistenceController.shared.context

    // Save user to the database
    func saveUser(name: String, email: String, password: String) {
        let user = AppUser(context: context)
        user.name = name
        user.email = email
        user.password = password
        do {
            try context.save()
            print("User saved successfully!")
        } catch {
            print("Failed to save user: \(error)")
        }
    }

    // Fetch user from the database
    func fetchUser(email: String, password: String) -> AppUser? {
        let request: NSFetchRequest<AppUser> = AppUser.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
        do {
            let results = try context.fetch(request)
            return results.first
        } catch {
            print("Failed to fetch user: \(error)")
            return nil
        }
    }

    // Save check-in/check-out action
    func saveCheckInOut(action: String, latitude: Double, longitude: Double) {
        let tracker = InOutTracker(context: context)
        tracker.timestamp = Date()
        tracker.action = action
        tracker.latitude = latitude
        tracker.longitude = longitude
        do {
            try context.save()
            print("\(action) saved successfully!")
        } catch {
            print("Failed to save \(action): \(error)")
        }
    }

    // Fetch check-in/check-out history
    func fetchCheckInOutHistory() -> [InOutTracker] {
        let request: NSFetchRequest<InOutTracker> = InOutTracker.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch history: \(error)")
            return []
        }
    }
}
