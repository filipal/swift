//
//  PasswordSetupView.swift
//  InOut Tracker
//
//  Created by Nives on 21.12.2024..
//

import Foundation
import SwiftUI

struct PasswordSetupView: View {
    let name: String
    let email: String
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @State private var navigateToSignIn = false

    var body: some View {
        VStack {
            Text("Setup Password")
                .font(.largeTitle)
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button("Signup") {
                if password.count >= 6 {
                    saveUserData(name: name, email: email, password: password)
                    navigateToSignIn = true
                } else {
                    errorMessage = "Password must be at least 6 characters."
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            NavigationLink("", destination: SignInView(), isActive: $navigateToSignIn)
        }
        .padding()
    }

    func saveUserData(name: String, email: String, password: String) {
        let context = PersistenceController.shared.container.viewContext
        let user = AppUser(context: context)
        user.name = name
        user.email = email
        user.password = password

        do {
            try context.save()
            print("User data saved: \(name), \(email)")
        } catch {
            print("Failed to save user: \(error)")
    }
}
}
