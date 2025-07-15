//
//  VideoConsultationViewModel.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 15/06/2025.
//

import Foundation
import AgoraRtcKit
import SwiftUI
import SwiftUICore

class VideoConsultationViewModel: NSObject, ObservableObject, AgoraRtcEngineDelegate {
    @Published var inCall = false
    @Published var isMuted = false
    @Published var connectionState: ConnectionState = .disconnected
    @Published var participants = 0

    
    var localVideoView = UIView()
    var remoteVideoView = UIView()
    
    private var agoraKit: AgoraRtcEngineKit?
    private let appID = "YOUR_AGORA_APP_ID" // Should be from config
    
    enum ConnectionState {
        case disconnected, connecting, connected, failed
    }
    
    override init() {
        super.init()
        initializeAgora()
    }
    
    private func initializeAgora() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: appID, delegate: self)
        agoraKit?.enableVideo()
        agoraKit?.enableAudio()
        agoraKit?.setChannelProfile(.communication)
        
        // Configure video settings
        let videoConfig = AgoraVideoEncoderConfiguration(
            size: CGSize(width: 640, height: 360),
            frameRate: .fps15,
            bitrate: AgoraVideoBitrateStandard,
            orientationMode: .adaptative, // ✅ correct spelling
            mirrorMode: .auto             // ✅ required parameter
        )

        agoraKit?.setVideoEncoderConfiguration(videoConfig)
        
        // Setup local video
        let localCanvas = AgoraRtcVideoCanvas()
        localCanvas.uid = 0
        localCanvas.view = localVideoView
        localCanvas.renderMode = .hidden
        agoraKit?.setupLocalVideo(localCanvas)
    }
    
    func joinChannel(channel: String, token: String? = nil) {
        connectionState = .connecting
        
        // Set up encryption for privacy
        let encryptionConfig = AgoraEncryptionConfig()
        encryptionConfig.encryptionMode = .AES128XTS
        encryptionConfig.encryptionKey = "your_encryption_secret"

        agoraKit?.enableEncryption(true, encryptionConfig: encryptionConfig)

        
        agoraKit?.joinChannel(
            byToken: token,
            channelId: channel,
            info: nil,
            uid: 0
        ) { [weak self] _, uid, _ in
            DispatchQueue.main.async {
                self?.inCall = true
                self?.connectionState = .connected
            }
        }
    }
    
    func endCall() {
        agoraKit?.leaveChannel { [weak self] _ in
            DispatchQueue.main.async {
                self?.inCall = false
                self?.connectionState = .disconnected
                self?.participants = 0
            }
        }
        
        // Clean up video views
        localVideoView.removeFromSuperview()
        remoteVideoView.removeFromSuperview()
    }
    
    func toggleMute() {
        isMuted.toggle()
        agoraKit?.muteLocalAudioStream(isMuted)
    }
    
    func switchCamera() {
        agoraKit?.switchCamera()
    }
    
    // MARK: - Agora Delegate Methods
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        DispatchQueue.main.async {
            let remoteCanvas = AgoraRtcVideoCanvas()
            remoteCanvas.uid = uid
            remoteCanvas.view = self.remoteVideoView
            remoteCanvas.renderMode = .fit
            self.agoraKit?.setupRemoteVideo(remoteCanvas)
            self.participants += 1
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        DispatchQueue.main.async {
            self.participants = max(0, self.participants - 1)
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, connectionChangedTo state: AgoraConnectionState, reason: AgoraConnectionChangedReason) {
        DispatchQueue.main.async {
            switch state {
            case .connecting, .reconnecting:
                self.connectionState = .connecting
            case .connected:
                self.connectionState = .connected
            case .disconnected, .failed:
                self.connectionState = .disconnected
            @unknown default:
                self.connectionState = .disconnected
            }
        }
    }
    
    deinit {
        endCall()
        AgoraRtcEngineKit.destroy()
    }
}
