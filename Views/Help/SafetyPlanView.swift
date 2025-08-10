//
//  SafetyPlanView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 16/06/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
import SwiftUICore

struct SafetyPlanView: View {
    
    
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")
    
    var body: some View {
        VStack {
            Text("Safety Plan")
                .font(.largeTitle)
                .padding()
            Text("This is where users can create a personalized safety plan.")
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}
