//
//  NewAsylumSeekerOnboardingView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 03/06/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
import SwiftUICore

struct NewAsylumSeekerOnboardingView: View {
    var onContinue: () -> Void
    @AppStorage("selectedLanguage") var selectedLanguage: String = "en"
    @State private var showRefEntry = false
    
    
    let primaryColor = Color(hex: "#0D3B66")  // Rich blue
    let accentColor = Color(hex: "#F95738")   // Bright coral-red
    let cardColor = Color(hex: "#FFFFFF")     // White
    let backgroundColor = Color(hex: "#F5F9FF") // Soft blue-white
    let textPrimary = Color(hex: "#1A1A1A")   // Neutral dark
    let textSecondary = Color(hex: "#555555") // Medium gray

    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(asylumTitle)
                            .font(.title)
                            .bold()
                            .foregroundColor(primaryColor)
                            .lineLimit(nil)
                        
                        Text(asylumDescription)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineLimit(nil)
                    }
                    .padding(.bottom, 10)
                    
                    // UK Asylum Process
                    VStack(alignment: .leading, spacing: 25) {
                        Text(localized("UK Asylum Process"))
                            .font(.headline)
                            .foregroundColor(primaryColor)
                            .lineLimit(nil)
                        
                        StepCard(
                            icon: "doc.text.fill",
                            title: step1Title,
                            description: step1Description,
                            color: primaryColor
                        )
                        
                        StepCard(
                            icon: "person.fill.questionmark",
                            title: step2Title,
                            description: step2Description,
                            color: accentColor
                        )
                        
                        StepCard(
                            icon: "clock.fill",
                            title: step3Title,
                            description: step3Description,
                            color: primaryColor
                        )
                        
                        StepCard(
                            icon: "house.fill",
                            title: step4Title,
                            description: step4Description,
                            color: accentColor
                        )
                        
                        StepCard(
                            icon: "person.2.fill",
                            title: step5Title,
                            description: step5Description,
                            color: primaryColor
                        )
                    }
                    .padding()
                    .background(backgroundColor)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                    
                    // Rights and Benefits
                    VStack(alignment: .leading, spacing: 20) {
                        Text(localized("Your Rights & Benefits"))
                            .font(.headline)
                            .foregroundColor(primaryColor)
                            .lineLimit(nil)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            BenefitItem(icon: "house.fill", text: localized("Access to housing"), color: primaryColor)
                            BenefitItem(icon: "heart.fill", text: localized("Free healthcare through NHS"), color: accentColor)
                            BenefitItem(icon: "book.fill", text: localized("Education for children (5-18 years)"), color: primaryColor)
                            BenefitItem(icon: "sterlingsign.circle.fill", text: localized("Financial support (£49.18/week)"), color: accentColor)
                            BenefitItem(icon: "gavel.fill", text: localized("Free legal advice"), color: primaryColor)
                            BenefitItem(icon: "hands.sparkles.fill", text: localized("Protection from deportation"), color: accentColor)
                        }
                        .padding(.vertical, 5)
                    }
                    .padding()
                    .background(backgroundColor)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                    
                    // Immediate Actions
                    VStack(alignment: .leading, spacing: 20) {
                        Text(localized("First Steps in the UK"))
                            .font(.headline)
                            .foregroundColor(primaryColor)
                            .lineLimit(nil)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            ImmediateActionItem(
                                icon: "phone.fill",
                                title: localized("Report to Authorities"),
                                description: localized("Visit a screening unit within 3 days of arrival"),
                                color: accentColor
                            )
                            
                            ImmediateActionItem(
                                icon: "doc.text.fill",
                                title: localized("Apply for Asylum"),
                                description: localized("Submit your application at the screening interview"),
                                color: primaryColor
                            )
                            
                            ImmediateActionItem(
                                icon: "mappin.and.ellipse",
                                title: localized("Register Your Address"),
                                description: localized("Update Home Office if you change accommodation"),
                                color: accentColor
                            )
                        }
                    }
                    .padding()
                    .background(backgroundColor)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                    
                    Spacer()
                    
                    Button(action: { showRefEntry = true }) {
                        Text(localized("Continue"))
                            .font(.headline)
                            .foregroundColor(.white)
                            .background(AppColors.primary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(primaryColor)
                            .cornerRadius(12)
                            .padding(.horizontal, 20)
                            .shadow(color: primaryColor.opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                    .padding(.bottom, 20)
                }
                .padding()
                .background(backgroundColor.ignoresSafeArea())
                .id("top")
            }
            .navigationTitle(asylumTitle)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                proxy.scrollTo("top", anchor: .top)
            }
        }
        .navigationDestination(isPresented: $showRefEntry) {
            EnterReferenceNumberView(
                title: localized("Enter Your Home Office Ref Number"),
                subtitle: localized("You'll find this on documents from the UK Home Office (e.g. A1234567)"),
                placeholder: "A1234567"
            ) { _ in
                onContinue()
            }
        }
    }
        // MARK: - Localized Content
        private var asylumTitle: String {
            localized("New Asylum Seeker's Guide")
        }
        
        private var asylumDescription: String {
            localized("Your comprehensive guide to starting your asylum journey in the UK")
        }
        
        private var step1Title: String {
            localized("Registration")
        }
        
        private var step1Description: String {
            localized("Start your journey by officially submitting your asylum application")
        }
        
        private var step2Title: String {
            localized("Screening Interview")
        }
        
        private var step2Description: String {
            localized("Initial meeting to verify identity and reasons for seeking asylum")
        }
        
        private var step3Title: String {
            localized("Waiting Period")
        }
        
        private var step3Description: String {
            localized("Decision may take several months. You'll receive temporary support")
        }
        
        private var step4Title: String {
            localized("Housing Support")
        }
        
        private var step4Description: String {
            localized("Temporary accommodation provided during the application process")
        }
        
        private var step5Title: String {
            localized("Main Interview")
        }
        
        private var step5Description: String {
            localized("Detailed meeting about your asylum reasons (bring all evidence)")
        }
        
        private func localized(_ key: String) -> String {
            NSLocalizedString(key, comment: "")
        }
        
        // MARK: - Custom Views
        struct StepCard: View {
            let icon: String
            let title: String
            let description: String
            let color: Color
            
            var body: some View {
                HStack(alignment: .top, spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(color.opacity(0.1))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: icon)
                            .foregroundColor(color)
                            .font(.system(size: 20))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.primary)
                            .lineLimit(nil)
                        Text(description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineLimit(nil)
                    }
                }
                .padding(.vertical, 5)
            }
        }
        
        struct BenefitItem: View {
            let icon: String
            let text: String
            let color: Color
            
            var body: some View {
                HStack(alignment: .top) {
                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.system(size: 20))
                        .frame(width: 30)
                    
                    Text(text)
                        .font(.subheadline)
                        .lineLimit(nil)
                }
            }
        }
        
        struct ImmediateActionItem: View {
            let icon: String
            let title: String
            let description: String
            let color: Color
            
            var body: some View {
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.system(size: 20))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.primary)
                        Text(description)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    struct NewAsylumSeekerOnboardingView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView {
                NewAsylumSeekerOnboardingView(onContinue: {})
            }
        }
    }
