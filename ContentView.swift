//
//  ContentView.swift
//  InOut Tracker
//
//  Created by Nives on 21.12.2024..
//

import SwiftUI

struct ContentView: View {
    @StateObject private var networkMonitor = NetworkMonitor()

    var body: some View {
        NavigationView {
            VStack {
                if !networkMonitor.isConnected {
                    Text("No internet connection")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    Text("Welcome to Biometric Attendance")
                        .font(.largeTitle)
                        .padding()
                        
                    SignupView()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
