//
//  ViewExtensions.swift
//  InOut Tracker
//
//  Created by Nives on 21.12.2024..
//

import Foundation
import SwiftUI

extension View {
    func appButtonStyle(background: Color = .blue) -> some View {
        self
            .padding()
            .background(background)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}
