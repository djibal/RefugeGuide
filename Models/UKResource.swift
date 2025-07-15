//
//  UKResource.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/06/2025.
//
import Foundation
import SwiftUI
import FirebaseFunctions

struct UKConstants {
    // UK-specific emergency numbers
    static let emergencyNumbers = [
        "Police": "999",
        "National Domestic Abuse Helpline": "0808 2000 247",
        "Refugee Council Helpline": "0808 196 7272",
        "NHS Non-emergency": "111"
    ]
    
    // UK regions with refugee support centers
    static let regionsWithSupport = [
        "London", "Birmingham", "Manchester", "Glasgow", "Liverpool",
        "Leeds", "Bristol", "Cardiff", "Belfast", "Newcastle"
    ]
    
    // Key UK refugee support organizations
    static let supportOrganizations = [
        "Refugee Council": "https://www.refugeecouncil.org.uk",
        "British Red Cross": "https://www.redcross.org.uk",
        "Refugee Action": "https://www.refugee-action.org.uk",
        "UK Refugee Support": "https://www.ukrefugeesupport.org"
    ]
    
    // UK government resources
    static let governmentResources = [
        "UK Visas and Immigration": "https://www.gov.uk/browse/visas-immigration",
        "Asylum Support": "https://www.gov.uk/asylum-support",
        "Refugee Integration Services": "https://www.gov.uk/refugee-integration"
    ]
}
