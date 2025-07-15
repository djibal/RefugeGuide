//
//  EVisaFormView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 06/08/2025.
//
import Foundation
import SwiftUI
import FirebaseFirestore
import Combine
import SwiftUICore
import FirebaseAuth




struct EVisaFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: EVisaViewModel

    @State private var fullName: String
    @State private var visaType: String
    @State private var expiryDate: Date
    @State private var currentStatus: String
    @State private var shareCode: String
    @State private var issuingCountry: String
    @State private var issuingAuthority: String
    
    let primaryColor = Color(hex: "#0D3B66")  // Rich blue
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")

    init(viewModel: EVisaViewModel) {
        self.viewModel = viewModel
        let data = viewModel.eVisaData
        _fullName = State(initialValue: data?.fullName ?? "")
        _visaType = State(initialValue: data?.visaType ?? "")
        _currentStatus = State(initialValue: data?.currentStatus ?? viewModel.statusOptions.first ?? "")
        _shareCode = State(initialValue: data?.shareCode ?? "")
        _issuingCountry = State(initialValue: data?.issuingCountry ?? "")
        _issuingAuthority = State(initialValue: data?.issuingAuthority ?? "")

        if let timestamp = data?.expiryDate {
            _expiryDate = State(initialValue: timestamp.dateValue())
        } else {
            _expiryDate = State(initialValue: Date())
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Full Name", text: $fullName)
                    TextField("Visa Type", text: $visaType)
                }

                Section(header: Text("Visa Details")) {
                    DatePicker("Expiry Date", selection: $expiryDate, displayedComponents: .date)

                    Picker("Current Status", selection: $currentStatus) {
                        ForEach(viewModel.statusOptions, id: \.self) { status in
                            Text(status).tag(status)
                        }
                    }

                    TextField("Share Code", text: $shareCode)
                    TextField("Issuing Country", text: $issuingCountry)
                    TextField("Issuing Authority", text: $issuingAuthority)
                }
            }
            .navigationTitle("eVisa Details")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    Task {
                        await saveData()
                    }
                }
            )
        }
    }

    private func saveData() async {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let timestamp = Timestamp(date: expiryDate)

        let data = EVisaData(
            userId: uid,
            fullName: fullName,
            visaType: visaType,
            expiryDate: timestamp,
            currentStatus: currentStatus,
            shareCode: shareCode,
            issuingCountry: issuingCountry,
            issuingAuthority: issuingAuthority
        )
        
        do {
            try await viewModel.saveEVisaData(data: data)
            presentationMode.wrappedValue.dismiss()
        } catch {
            // Here you could trigger an alert to show the error
            print("Failed to save eVisa data: \(error.localizedDescription)")
        }
    }
}
