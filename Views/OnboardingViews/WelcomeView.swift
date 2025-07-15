//
//  WelcomeView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/06/2025.
//
import Foundation
import SwiftUI
import FirebaseFunctions

struct WelcomeView: View {
    var onContinue: () -> Void
    @AppStorage("selectedLanguage") var selectedLanguage: String = "en"

    @State private var animate = false

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 30) {
                    Spacer()

                    Image("RefugeGuideLogo")
                        .resizable()
                        .scaledToFill()  // Changed from scaledToFit
                        .frame(width: 120, height: 120)  // Fixed square dimensions
                        .clipShape(Circle())  // Makes the image circular
                        .accessibilityLabel(Text("RefugeGuide logo"))
                        //.clipShape(Circle())
                       // .overlay(Circle().stroke(Color.white, lineWidth: 2))  // Optional border
                    
                    Text(welcomeTitle)
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                        .lineLimit(nil) // Ensure full text display
                        .opacity(animate ? 1 : 0)
                        .animation(.easeInOut.delay(0.2), value: animate)

                    Text(welcomeMessage)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 40)
                        .lineLimit(nil) // Ensure full text display
                        .opacity(animate ? 1 : 0)
                        .animation(.easeInOut.delay(0.4), value: animate)

                    Spacer()

                    Button(action: onContinue) {
                        Text(localizedContinue)
                            .font(.title3)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    .accessibilityLabel(Text(localizedContinue))
                    .padding(.bottom, 20)
                    .opacity(animate ? 1 : 0)
                    .animation(.easeInOut.delay(0.6), value: animate)
                }
                .padding()
                .id("top") // Identifier for scrolling
            }
            .onAppear {
                animate = true
                proxy.scrollTo("top", anchor: .top)
            }
        }
    }

    private var welcomeTitle: String {
        switch selectedLanguage {
        case "ar": return "مرحبًا بك في دليل اللاجئين"
        case "fr": return "Bienvenue sur RefugeGuide"
        case "fa": return "به RefugeGuide خوش آمدید"
        case "ur": return "RefugeGuide میں خوش آمدید"
        case "uk": return "Ласкаво просимо до RefugeGuide"
        case "ps": return "RefugeGuide ته ښه راغلاست"
        case "ku": return "بەخێربێن بۆ RefugeGuide"
        default: return "Welcome to RefugeGuide"
        }
    }

    private var welcomeMessage: String {
        switch selectedLanguage {
        case "ar": return "مرشدك الموثوق خلال عملية اللجوء في المملكة المتحدة"
        case "fr": return "Votre compagnon de confiance dans le processus d'asile au Royaume-Uni"
        case "fa": return "همراه قابل اعتماد شما در فرآیند پناهندگی در بریتانیا"
        case "ur": return "یوکے میں پناہ کے عمل کے دوران آپ کا قابل اعتماد ساتھی"
        case "uk": return "Ваш надійний помічник у процесі отримання притулку у Великій Британії"
        case "ps": return "ستاسو د باور وړ ملګری د انګلستان د پناه غوښتنې په بهیر کې"
        case "ku": return "هاوڕێیەکی بە باوەر بۆ بەڕێوەچوونی پرۆسەی پناهندەیی لە بەریتانیا"
        default: return "Your trusted companion through the UK asylum process"
        }
    }

    private var localizedContinue: String {
        switch selectedLanguage {
        case "ar": return "استمر"
        case "fr": return "Continuer"
        case "fa": return "ادامه"
        case "ur": return "جاری رکھیں"
        case "uk": return "Продовжити"
        case "ps": return "دوام ورکړئ"
        case "ku": return "بەرەوپێش بە"
        default: return "Continue"
        }
    }
}
