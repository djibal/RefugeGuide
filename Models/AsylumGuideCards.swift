//
//  AsylumGuideCards.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 03/07/2025.
//

import Foundation
import SwiftUI

struct AsylumGuideCardsProvider {
    static func cards(for language: String) -> [GuideCardData] {
        return [
            GuideCardData(
                title: "Step 1: Initial Screening",
                description: "You’ll be interviewed at the UK border or Home Office.",
                icon: "magnifyingglass",
                linkText: "Read More",
                linkURL: "https://www.gov.uk/asylum-screening"
            ),
            GuideCardData(
                title: "Step 2: Asylum Interview",
                description: "You’ll explain why you are seeking asylum.",
                icon: "person.fill.questionmark",
                linkText: "Interview Help",
                linkURL: "https://www.gov.uk/asylum-interview"
            ),
            GuideCardData(
                title: "Step 3: Decision",
                description: "The Home Office will send you a decision letter.",
                icon: "envelope.badge",
                linkText: "Decision Outcome",
                linkURL: "https://www.gov.uk/asylum-decision"
            )
        ]
    }
}
