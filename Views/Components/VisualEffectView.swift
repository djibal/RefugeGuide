//
//  VisualEffectView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 01/07/2025.
//

import SwiftUI

struct VisualEffectView: UIViewRepresentable {
    let effect: UIVisualEffect?

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: effect)
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = effect
    }
}
