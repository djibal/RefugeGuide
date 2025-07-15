//
//  AnimationView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 18/07/2025.
//

import Foundation
import SwiftUI
import SwiftUICore

struct SplashScreenView: View {
    @State private var isAnimating = false
    @State private var showMainApp = false
    @State private var gradientOffset: CGFloat = 0
    @State private var patternRotation: Double = 0
    @State private var letters: [String] = []
    @State private var subtitleVisible = false

    @AppStorage("selectedLanguage") var selectedLanguage: String = "en"

    let appName = "RefugeGuide"
    let haptic = UIImpactFeedbackGenerator(style: .soft)

    var body: some View {
        ZStack {
            // Animated Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [
                    AppColors.primary,
                    AppColors.primary.opacity(0.7),
                    AppColors.primary
                ]),
                startPoint: .topLeading,
                endPoint: .init(x: cos(gradientOffset), y: sin(gradientOffset))
            )
            .ignoresSafeArea()

            // Animated Circles
            ForEach(0..<8) { i in
                Circle()
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [AppColors.cardBackground.opacity(0.15), .clear]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
                    .frame(width: CGFloat(120 + i * 70), height: CGFloat(120 + i * 70))
                    .rotationEffect(.degrees(patternRotation))
                    .offset(
                        x: isAnimating ? sin(CGFloat(i)) * 25 : 0,
                        y: isAnimating ? cos(CGFloat(i)) * 25 : 0
                    )
                    .opacity(isAnimating ? 0.3 : 0)
            }

            if !showMainApp {
                VStack(spacing: 8) {
                    // App Name Animation
                    HStack(spacing: 0) {
                        ForEach(letters.indices, id: \.self) { index in
                            Text(letters[index])
                                .font(.system(size: 46, weight: .bold, design: .rounded))
                                .foregroundColor(AppColors.cardBackground)
                                .offset(y: isAnimating ? 0 : 60)
                                .opacity(isAnimating ? 1 : 0)
                                .scaleEffect(isAnimating ? 1 : 0.1)
                                .rotation3DEffect(
                                    .degrees(isAnimating ? 0 : 45),
                                    axis: (x: 1.0, y: 0.0, z: 0.0),
                                    perspective: 0.2
                                )
                                .animation(
                                    .interpolatingSpring(stiffness: 130, damping: 12)
                                    .delay(Double(index) * 0.08),
                                    value: isAnimating
                                )
                        }
                    }

                    // Subtitle
                    if subtitleVisible {
                        Text("Stay On Track")
                            .font(.system(size: 18, weight: .thin))
                            .foregroundColor(AppColors.cardBackground.opacity(0.85))
                            .tracking(2.5)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                            .offset(y: isAnimating ? 0 : 10)
                            .opacity(isAnimating ? 1 : 0)
                            .animation(.easeOut(duration: 1.2).delay(1.0), value: isAnimating)
                    }
                }
                .offset(y: -20)
            } else {
                // Main Content after animation
                MainContentView(showMainApp: showMainApp)

                // Optional: launch language picker or app root logic elsewhere if needed
            }
        }
        .onAppear {
            letters = appName.map { String($0) }

            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                gradientOffset = 2 * .pi
            }

            withAnimation(.linear(duration: 16).repeatForever(autoreverses: false)) {
                patternRotation = 360
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.spring()) {
                    isAnimating = true
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation {
                    subtitleVisible = true
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                haptic.impactOccurred()
                withAnimation(.easeInOut(duration: 0.8)) {
                    showMainApp = true
                }
            }
        }
    }
}

// MARK: - Main Content View

struct MainContentView: View {
    let showMainApp: Bool

    var body: some View {
        VStack {
            Image(systemName: "mappin.and.ellipse")
                .font(.system(size: 60))
                .foregroundColor(AppColors.cardBackground)
                .padding()
                .rotationEffect(showMainApp ? .degrees(5) : .degrees(0))
                .animation(.easeInOut(duration: 0.3).repeatForever(autoreverses: true), value: showMainApp)

            Text("Welcome to RefugeGuide")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(AppColors.cardBackground)
                .opacity(0.9)
        }
    }
}

// MARK: - Preview

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}

