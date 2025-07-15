//
//  AgoraVideoViewRepresentable.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 15/06/2025.
//
import Foundation
import SwiftUI
import FirebaseFunctions
import AgoraRtcKit

struct AgoraVideoViewRepresentable: UIViewRepresentable {
    let canvas: AgoraRtcVideoCanvas

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Update video canvas settings
        AgoraManager.shared.agoraKit.setupRemoteVideo(canvas)
    }
}
