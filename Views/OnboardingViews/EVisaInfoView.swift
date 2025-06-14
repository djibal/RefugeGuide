//
//  EVisaInfoView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/06/2025.
//


import SwiftUI

struct EVisaInfoView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // Main Heading
                Text("What is an eVisa?")
                    .font(.title)
                    .bold()

                // Introduction
                Text("""
An **eVisa** is a secure, digital record of your UK immigration status.

It replaces physical documents like the Biometric Residence Permit (BRP), and shows your permission to live, work, or study in the UK.
""")

                Text("""
To use your eVisa, you must create a **UKVI online account**. Your immigration status doesn’t change — only the way you prove it.
""")

                Divider()

                // Benefits
                Text("🔒 Why Use an eVisa?")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 10) {
                    Label("Secure: Can't be lost, stolen, or damaged", systemImage: "lock.shield")
                    Label("Accessible online 24/7 from anywhere", systemImage: "globe")
                    Label("No need to collect or carry a physical card", systemImage: "doc")
                    Label("Faster status checks at airports and borders", systemImage: "airplane.departure")
                    Label("Easier sharing with employers, landlords, schools", systemImage: "person.2.wave.2")
                }

                Divider()

                // How to Use It
                Text("💡 How Do I Use My eVisa?")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 10) {
                    Text("• Log into your UKVI account to view your status or update your details.")
                    Text("• Generate a **share code** when asked to prove your status (valid for 90 days).")
                    Text("• Travel using your **current passport**, which must be linked to your eVisa.")
                }

                Divider()

                // External link
                Link("Go to the official UKVI eVisa Portal",
                     destination: URL(string: "https://www.gov.uk/view-prove-immigration-status")!)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                // Footer
                Text("💬 If you have trouble accessing your eVisa or need to update your passport, contact the UKVI support team.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.top, 10)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("About eVisas")
    }
}
