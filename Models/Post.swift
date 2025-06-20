//
//  Post.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 19/06/2025.
//


import Foundation

struct Post: Identifiable, Codable, Equatable {
    let id: String
    let userId: String
    let title: String
    let content: String
    let timestamp: Date
    var isReported: Bool = false
}
