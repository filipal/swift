//
//  SignInView.swift
//  InOut Tracker
//
//  Created by Nives on 21.12.2024..
//

import Foundation
import SwiftUI
import CoreData

struct SignInView: View {
    @StateObject private var networkMonitor = NetworkMonitor() // Jedna instanca za provjeru mreže
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @State private var navigateToHome = false

    var body: some View {
        VStack {
            // Provjera mrežne povezanosti
            if !networkMonitor.isConnected {
                Text("No internet connection.")
                    .foregroundColor(.red)
                    .padding()
            }

            Text("Sign In")
                .font(.largeTitle)
                .padding()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button("Login") {
                if authenticateUser(email: email, password: password) {
                    navigateToHome = true
                } else {
                    errorMessage = "Invalid credentials. Please try again."
                }
            }
            .padding()
            .background(networkMonitor.isConnected ? Color.blue : Color.gray) // Sivi gumb bez interneta
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(!networkMonitor.isConnected) // Onemogućeno kad nema interneta

            NavigationLink("", destination: HomeView(), isActive: $navigateToHome)
        }
        .padding()
    }

    // Funkcija za provjeru vjerodajnica
    func authenticateUser(email: String, password: String) -> Bool {
        let context = PersistenceController.shared.context
        let request: NSFetchRequest<AppUser> = AppUser.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)

        do {
            let results = try context.fetch(request)
            return !results.isEmpty
        } catch {
            print("Failed to fetch user: \(error)")
            return false
        }
    }
}
