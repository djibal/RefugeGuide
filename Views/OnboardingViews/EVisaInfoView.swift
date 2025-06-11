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
            VStack(alignment: .leading, spacing: 16) {
                Text("What is an eVisa?")
                    .font(.title)
                    .bold()

                Text("""
An eVisa is an online record of your immigration status and the conditions of your permission to enter or stay in the UK.

You need to create a UKVI account to access your eVisa. Updating from a physical document (like a BRP) to an eVisa does **not change your immigration status**.
""")

                Divider()

                Text("🔒 Benefits of eVisas")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 8) {
                    Label("Secure – cannot be lost, stolen or tampered with", systemImage: "lock.shield")
                    Label("No need to collect a physical document", systemImage: "doc")
                    Label("Faster status checks at the UK border", systemImage: "airplane.departure")
                    Label("Easier to share with employers, landlords, and schools", systemImage: "person.2.wave.2")
                }

                Divider()

                Text("💡 How to Use It")
                    .font(.headline)

                Text("""
- You can generate a **share code** to prove your status (valid for 90 days).
- You can update your contact or passport details in your UKVI account.
- Travel with your current passport, which must be linked to your eVisa.
""")

                Divider()

                Link("Go to the official UKVI eVisa Portal",
                     destination: URL(string: "https://www.gov.uk/view-prove-immigration-status")!)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("About eVisas")
    }
}

#Preview {
    EVisaInfoView()
}
