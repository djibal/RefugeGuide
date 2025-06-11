//
//  RegistrationView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/06/2025.
//

import SwiftUI

struct RegistrationView: View {
    @State private var firstName = ""
    @State private var preferredName = ""
    @State private var middleName = ""
    @State private var lastName = ""
    @State private var agreedToPolicy = false

    var body: some View {
        // START OF NavigationStack
        NavigationStack {
            Form {
                Section(header: Text("Personal Details")) {
                    TextField("First Name", text: $firstName)
                    TextField("Preferred Name (optional)", text: $preferredName)
                    TextField("Middle Name (optional)", text: $middleName)
                    TextField("Last Name", text: $lastName)
                }

                Section {
                    Toggle(isOn: $agreedToPolicy) {
                        Text("I agree to RefugeGuide’s Data Use Policy (linked) per UK GDPR.")
                    }
                }

                Section {
                    NavigationLink(destination: UserTypeSelectionView()) {
                        Text("Continue")
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(!formIsValid)
                }
            }
            .navigationTitle("Registration")
        }
        // END OF NavigationStack
    }

    var formIsValid: Bool {
        !firstName.isEmpty && !lastName.isEmpty && agreedToPolicy
    }
}
