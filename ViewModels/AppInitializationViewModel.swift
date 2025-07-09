//
//  AppInitializationViewModel.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 08/07/2025.
//

import Foundation
import FirebaseCore
import SwiftUI

class AppInitializationViewModel: ObservableObject {
    @Published var isFirebaseReady = false

    init() {
        DispatchQueue.main.async {
            if FirebaseApp.app() != nil {
                self.isFirebaseReady = true
            } else {
                // Fallback check if initialization is slightly delayed
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.isFirebaseReady = FirebaseApp.app() != nil
                }
            }
        }
    }
}
