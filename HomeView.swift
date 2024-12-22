//
//  HomeView.swift
//  InOut Tracker
//
//  Created by Nives on 21.12.2024..
//

import Foundation
import SwiftUI
import LocalAuthentication
import CoreLocation

struct HomeView: View {
    @ObservedObject var networkMonitor = NetworkMonitor() // Network monitoring
    @StateObject private var locationManager = LocationManager() // Location manager
    @State private var message: String = ""
    @State private var todos: [ToDo] = [] // API data
    @State private var errorMessage: String? // Error message
    @State private var isAlreadyCheckedIn: Bool = false // Track check-in status

    // Office location (update coordinates as needed)
    private let officeLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)

    var body: some View {
        VStack {
            Text("Home")
                .font(.largeTitle)
                .padding()

            // Display current location
            if let location = locationManager.currentLocation {
                Text("Current Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                    .padding()
            } else {
                Text("Fetching location...")
                    .padding()
            }

            // Check-In Button
            Button("Check In") {
                handleCheckIn()
            }
            .padding()
            .background(isAlreadyCheckedIn ? Color.gray : Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(isAlreadyCheckedIn) // Disable if already checked in

            // Check-Out Button
            Button("Check Out") {
                handleCheckOut()
            }
            .padding()
            .background(isAlreadyCheckedIn ? Color.red : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(!isAlreadyCheckedIn) // Enable only if checked in

            // Network connectivity check
            if !networkMonitor.isConnected {
                Text("No internet connection.")
                    .foregroundColor(.red)
                    .padding()
            }

            // Fetch Data Button
            Button("Fetch Data") {
                fetchData()
            }
            .padding()
            .background(networkMonitor.isConnected ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(!networkMonitor.isConnected)

            // Display messages or data
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                List(todos) { todo in
                    Text(todo.title)
                }
            }

            if !message.isEmpty {
                Text(message)
                    .padding()
            }
        }
        .padding()
    }

    // Handle Check-In
    func handleCheckIn() {
        guard !isAlreadyCheckedIn else {
            message = "You have already checked in for the day."
            return
        }

        handleBiometricAuthentication(for: "Check In") { success in
            if success {
                if verifyLocation() {
                    UserManager.shared.saveCheckInOut(action: "Check In",
                                                      latitude: locationManager.currentLocation?.coordinate.latitude ?? 0,
                                                      longitude: locationManager.currentLocation?.coordinate.longitude ?? 0)
                    message = "Check-In Successful!"
                    isAlreadyCheckedIn = true
                } else {
                    message = "You are not at the office."
                }
            }
        }
    }

    // Handle Check-Out
    func handleCheckOut() {
        guard isAlreadyCheckedIn else {
            message = "You must check in first."
            return
        }

        handleBiometricAuthentication(for: "Check Out") { success in
            if success {
                if verifyLocation() {
                    UserManager.shared.saveCheckInOut(action: "Check Out",
                                                      latitude: locationManager.currentLocation?.coordinate.latitude ?? 0,
                                                      longitude: locationManager.currentLocation?.coordinate.longitude ?? 0)
                    message = "Check-Out Successful!"
                    isAlreadyCheckedIn = false
                } else {
                    message = "You are not at the office."
                }
            }
        }
    }

    // Biometric Authentication
    func handleBiometricAuthentication(for action: String, completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate to \(action)") { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        completion(true)
                    } else {
                        message = "Authentication failed. Please try again."
                        completion(false)
                    }
                }
            }
        } else {
            message = "Biometric authentication not available."
            completion(false)
        }
    }

    // Verify Location
    func verifyLocation() -> Bool {
        guard let userLocation = locationManager.currentLocation else { return false }
        return userLocation.distance(from: officeLocation) < 100 // 100 meters range
    }

    // Fetch Data from API
    func fetchData() {
        guard networkMonitor.isConnected else {
            errorMessage = "No internet connection. Cannot fetch data."
            return
        }

        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos") else {
            errorMessage = "Invalid URL."
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    errorMessage = "No data received from server."
                }
                return
            }

            do {
                let todos = try JSONDecoder().decode([ToDo].self, from: data)
                DispatchQueue.main.async {
                    self.todos = todos
                    errorMessage = nil
                }
            } catch {
                DispatchQueue.main.async {
                    errorMessage = "Failed to parse data: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}

// Struct for ToDo
struct ToDo: Identifiable, Codable {
    let id: Int
    let title: String
    let completed: Bool
}
