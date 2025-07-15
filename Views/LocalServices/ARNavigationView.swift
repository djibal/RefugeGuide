//
//  ARNavigationView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 15/06/2025.

import Foundation
import SwiftUI
import FirebaseFunctions
import ARKit
import CoreLocation


struct ARNavigationView: View {
    @StateObject private var arVM = ARNavigationViewModel()
    @Environment(\.presentationMode) var presentationMode
    let destinationCoordinate: CLLocationCoordinate2D
    let destinationName: String

    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewRepresentable(viewModel: arVM, destination: destinationCoordinate)
                .edgesIgnoringSafeArea(.all)

            VStack {
                // Custom navigation bar
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .padding()
                    }

                    Spacer()

                    Text("AR Navigation")
                        .font(.headline)

                    Spacer()

                    // For symmetry
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .padding()
                        .hidden()
                }
                .foregroundColor(.white)
                .background(Color.black.opacity(0.5))

                Spacer()

                NavigationPanel(viewModel: arVM, destinationName: destinationName)
                    .padding(.bottom, 30)
            }
        }
        .onDisappear {
            arVM.stopNavigation()
        }
    }
}

// MARK: - AR View Representable
private struct ARViewRepresentable: UIViewRepresentable {
    let viewModel: ARNavigationViewModel
    let destination: CLLocationCoordinate2D

    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView()
        viewModel.setupARView(arView, destination: destination)
        return arView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {}
}

// MARK: - Navigation Panel
private struct NavigationPanel: View {
    @ObservedObject var viewModel: ARNavigationViewModel
    let destinationName: String

    var body: some View {
        VStack(spacing: 16) {
            Text(destinationName)
                .font(.headline)
                .foregroundColor(.primary)

            if viewModel.isSetupComplete {
                Text("\(Int(viewModel.distanceToDestination)) meters")
                    .font(.title2)
                    .foregroundColor(.primary)

                Text(viewModel.instructions)
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            } else {
                ProgressView("Initializing AR navigation...")
            }

            TheLegalNotice(text: "AR navigation should be used as guidance only. Always follow official signage.")
        }
        .padding()
        .background(BlurView(style: .systemUltraThinMaterial))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

// MARK: - Legal Notice
private struct TheLegalNotice: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding(.top, 8)
    }
}

// MARK: - BlurView for Background Blur
private struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

// MARK: - View Extensions
extension View {
    func hidden(_ shouldHide: Bool = true) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}
