//
//  HelpResource.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 16/06/2025.
//

import Foundation

struct HelpResource: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let iconName: String
    let urlString: String?
    let type: ResourceType
}

enum ResourceType {
    case phone, web, email, inApp
}
