//
//  HelpResourcesViewModel.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 16/06/2025.
//
import Foundation
import SwiftUI
import FirebaseFunctions

final class HelpResourcesViewModel: ObservableObject {

    @Published var resources: [HelpResource] = [
        HelpResource(
            title: "Crisis Hotline",
            description: "24/7 mental health and suicide prevention support",
            iconName: "phone.fill",
            urlString: "tel://116123",
            type: ResourceType.phone,
            isCritical: true,
            category: UserResourceCategory.mentalHealth,
            contactInfo: "Samaritans UK (Freephone 116 123)",
            languages: ["en"],
            inAppDestination: nil,
            location: nil,
            distance: nil
        ),
        HelpResource(
            title: "Safety Planning",
            description: "Create a personalized safety plan for domestic abuse or emergencies",
            iconName: "shield.lefthalf.fill",
            urlString: nil,
            type: ResourceType.inApp,
            isCritical: true,
            category: UserResourceCategory.safety,
            contactInfo: "Use built-in planning tool",
            languages: ["en", "ar", "ur", "fa"],
            inAppDestination: "SafetyPlanView",
            location: nil,
            distance: nil
        ),
        HelpResource(
            title: "Resource Directory",
            description: "Search local shelters, clinics, food banks, and legal aid services",
            iconName: "map.fill",
            urlString: "https://refugeguide.org/directory",
            type: ResourceType.web,
            isCritical: false,
            category: UserResourceCategory.community,
            contactInfo: "RefugeGuide Online Directory",
            languages: ["en"],
            inAppDestination: nil,
            location: nil,
            distance: nil
        ),
        HelpResource(
            title: "Contact Support",
            description: "Reach the RefugeGuide help team by email",
            iconName: "envelope.fill",
            urlString: "mailto:support@refugeguide.org",
            type: ResourceType.email,
            isCritical: false,
            category: UserResourceCategory.generalSupport,
            contactInfo: "support@refugeguide.org",
            languages: ["en"],
            inAppDestination: nil,
            location: nil,
            distance: nil
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
