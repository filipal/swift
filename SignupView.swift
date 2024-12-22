//
//  SignupView.swift
//  InOut Tracker
//
//  Created by Nives on 21.12.2024..
//

import Foundation
import SwiftUI

struct SignupView: View {
    @ObservedObject var networkMonitor = NetworkMonitor() // Provjera interneta
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var errorMessage: String = ""
    @State private var navigateToPasswordSetup = false

    var body: some View {
        NavigationView {
            VStack {
                // Upozorenje o mrežnoj povezanosti
                if !networkMonitor.isConnected {
                    Text("No internet connection. Please check your connection.")
                        .foregroundColor(.red)
                        .padding()
                }

                Text("Signup")
                    .font(.largeTitle)
                    .padding()

                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .keyboardType(.emailAddress)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                // Gumb za prijelaz na postavljanje lozinke
                Button("Next") {
                    if validateEmail(email) {
                        navigateToPasswordSetup = true
                    } else {
                        errorMessage = "Please enter a valid email address."
                    }
                }
                .appButtonStyle(background: networkMonitor.isConnected ? .green : .gray)
                .padding()
                .background(networkMonitor.isConnected ? Color.blue : Color.gray) // Gumb postaje sivi bez interneta
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(!networkMonitor.isConnected) // Onemogućeno bez interneta

                // Gumb za spremanje korisnika i prijelaz na sljedeći ekran
                Button("Register") {
                    if validateEmail(email) {
                        UserManager.shared.saveUser(name: name, email: email, password: "") // Spremanje korisnika
                        navigateToPasswordSetup = true
                    } else {
                        errorMessage = "Please enter a valid email address."
                    }
                }
                .padding()
                .background(networkMonitor.isConnected ? Color.green : Color.gray) // Gumb postaje sivi bez interneta
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(!networkMonitor.isConnected) // Onemogućeno bez interneta

                // Navigacija na postavljanje lozinke
                NavigationLink("", destination: PasswordSetupView(name: name, email: email), isActive: $navigateToPasswordSetup)
            }
            .padding()
        }
    }

    func validateEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}
