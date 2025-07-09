//
//  SecureConfig.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 30/06/2025.
//


struct SecureConfig {
    // removed due more safe methode implementation ( static let openAIAPIKey = "")
    
    static let agoraAppId = "edb8f567d38a4d60b39aab7452a38b81"
    static let googleMapsAPIKey = "REDACTED"
   // static let firebaseConfigFile = "GoogleService-Info.plist"
    
    
    // UK Government APIs
        static let ukHomeOfficeAPIKey = "YOUR_HOME_OFFICE_API_KEY"
        static let ukDWPBenefitsAPIKey = "YOUR_DWP_BENEFITS_KEY"
        static let ukLocationServicesAPIKey = "YOUR_LOCATION_SERVICES_KEY"
        static let nhsHealthAPIKey = "YOUR_NHS_API_KEY"
        
        // Add endpoint constants
        static let asylumCaseEndpoint = "https://api.gov.uk/asylum/case/v1/"
        static let legalAidEndpoint = "https://api.gov.uk/legal-aid/v2/providers"
        static let benefitsEndpoint = "https://api.gov.uk/benefits/status/v3/"
    
    // Add more as needed
}
 
