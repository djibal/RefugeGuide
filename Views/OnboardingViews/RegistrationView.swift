//
//  RegistrationView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/06/2025.
//
import SwiftUI

struct RegistrationView: View {
    @AppStorage("firstName") private var firstName = ""
    @AppStorage("preferredName") private var preferredName = ""
    @AppStorage("middleName") private var middleName = ""
    @AppStorage("lastName") private var lastName = ""
    @AppStorage("agreedToPolicy") private var agreedToPolicy = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Personal Details")) {
                    TextField("First Name", text: $firstName)
                        .autocapitalization(.words)

                    TextField("Preferred Name (optional)", text: $preferredName)
                        .autocapitalization(.words)

                    TextField("Middle Name (optional)", text: $middleName)
                        .autocapitalization(.words)

                    TextField("Last Name", text: $lastName)
                        .autocapitalization(.words)
                }

                Section {
                    Toggle(isOn: $agreedToPolicy) {
                        HStack(spacing: 4) {
                            Text("I agree to RefugeGuide’s")
                            Link("Data Use Policy", destination: URL(string: "https://refugeguide.org/privacy")!)
                                .foregroundColor(.blue)
                                .underline()
                            Text("per UK GDPR.")
                        }
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
    }

    var formIsValid: Bool {
        !firstName.isEmpty && !lastName.isEmpty && agreedToPolicy
    }
}
