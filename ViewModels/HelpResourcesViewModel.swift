//
//  HelpResourcesViewModel.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 16/06/2025.
//

import SwiftUI

final class HelpResourcesViewModel: ObservableObject {
    @Published var resources: [HelpResource] = [
        HelpResource(
            title: NSLocalizedString("Crisis Hotline", comment: ""),
            description: NSLocalizedString("24/7 immediate support", comment: ""),
            iconName: "phone.fill",
            urlString: "tel://18002738255",
            type: .phone
        ),
        HelpResource(
            title: NSLocalizedString("Safety Planning", comment: ""),
            description: NSLocalizedString("Create a personalized safety plan", comment: ""),
            iconName: "doc.text.fill",
            urlString: nil,
            type: .inApp
        ),
        HelpResource(
            title: NSLocalizedString("Resource Directory", comment: ""),
            description: NSLocalizedString("Find local shelters and services", comment: ""),
            iconName: "map.fill",
            urlString: "https://refugeguide.org/directory",
            type: .web
        ),
        HelpResource(
            title: NSLocalizedString("Contact Support", comment: ""),
            description: NSLocalizedString("Reach our support team", comment: ""),
            iconName: "envelope.fill",
            urlString: "mailto:support@refugeguide.org",
            type: .email
        )
    ]
    
    func handleResourceTap(_ resource: HelpResource) {
        guard let urlString = resource.urlString,
              let url = URL(string: urlString),
              UIApplication.shared.canOpenURL(url) else {
            print("Invalid URL or in-app navigation")
            return
        }
        UIApplication.shared.open(url)
    }
}
