//
//  Resource.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/06/2025.
//


import Foundation

struct Resource: Identifiable {
    let id = UUID()
    let name: String
    let description: String
}

let sampleResources = [
    Resource(name: "Legal Assistance", description: "Free legal consultations"),
    Resource(name: "Housing Support", description: "Temporary shelter options"),
    Resource(name: "Language Classes", description: "Free English lessons")
]
