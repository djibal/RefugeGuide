//
//  AgoraManager.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 05/07/2025.
//

import Foundation
import AgoraRtcKit
import SwiftUI
import FirebaseFunctions

class AgoraManager {
    static let shared = AgoraManager()
    var agoraKit: AgoraRtcEngineKit!

    private init() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: "YOUR_AGORA_APP_ID", delegate: nil) // Should be from config
        agoraKit.setChannelProfile(.communication)
        agoraKit.enableVideo()
    }
}
