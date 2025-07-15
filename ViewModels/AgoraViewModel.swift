
//
//  AgoraViewModel.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 18/07/2025.
//


import Foundation
import SwiftUI
import FirebaseFunctions
import AgoraRtcKit
import SwiftUICore

class AgoraViewModel: NSObject, ObservableObject {
    private var agoraKit: AgoraRtcEngineKit?
    @Published var localVideoView: UIView?
    @Published var remoteVideoView: UIView?
    @Published var remoteUserId: UInt = 0
    @Published var isAudioEnabled = true
    @Published var isVideoEnabled = true
    @Published var isSpeakerOn = true
    @Published var callState: CallState = .connecting
    @Published var callDuration = "00:00"
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var advisorName = "Legal Advisor"

    private var callStartTime: Date?
    private var timer: Timer?
    
    enum CallState {
        case connecting, connected, ended, failed

        var description: String {
            switch self {
            case .connecting: return "Connecting..."
            case .connected: return "Connected"
            case .ended: return "Call Ended"
            case .failed: return "Connection Failed"
            }
        }
    }

    override init() {
        super.init()
        initializeAgora()
    }

    deinit {
        leaveChannel()
    }

    private func initializeAgora() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(
            withAppId: SecureConfig.agoraAppId,
            delegate: self
        )

        agoraKit?.enableVideo()
        agoraKit?.setChannelProfile(.communication)
        agoraKit?.setDualStreamMode(.autoSimulcastStream)

        let videoConfig = AgoraVideoEncoderConfiguration(
            size: AgoraVideoDimension640x360,
            frameRate: .fps15,
            bitrate: AgoraVideoBitrateStandard,
            orientationMode: .adaptative,
            mirrorMode: .auto
        )

        agoraKit?.setVideoEncoderConfiguration(videoConfig)
        agoraKit?.enableAudio()
        agoraKit?.setDefaultAudioRouteToSpeakerphone(true)
    }

    func joinChannel(for consultation: Consultation) {
        let channelId = consultation.id ?? "default"

        AgoraTokenService().getToken(forChannel: channelId) { result in
            switch result {
            case .success(let token):
                DispatchQueue.main.async {
                    self.joinChannel(withToken: token, channel: channelId)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showError(message: "Failed to get token: \(error.localizedDescription)")
                }
            }
        }
    }

    private func joinChannel(withToken token: String, channel: String) {
        let uid: UInt = 0

        agoraKit?.joinChannel(
            byToken: token,
            channelId: channel,
            info: nil,
            uid: uid,
            joinSuccess: nil
        )

        let localView = UIView()
        self.localVideoView = localView
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = localView
        videoCanvas.renderMode = .hidden
        agoraKit?.setupLocalVideo(videoCanvas)
        agoraKit?.startPreview()

        callStartTime = Date()
        startTimer()
        callState = .connecting
    }

    func leaveChannel() {
        agoraKit?.leaveChannel(nil)
        stopTimer()
        callState = .ended
    }

    func toggleMic() {
        isAudioEnabled.toggle()
        agoraKit?.muteLocalAudioStream(!isAudioEnabled)
    }

    func toggleCamera() {
        isVideoEnabled.toggle()
        agoraKit?.muteLocalVideoStream(!isVideoEnabled)
        localVideoView?.isHidden = !isVideoEnabled
    }

    func toggleSpeaker() {
        isSpeakerOn.toggle()
        agoraKit?.setEnableSpeakerphone(isSpeakerOn)
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let startTime = self?.callStartTime else { return }
            let interval = Int(Date().timeIntervalSince(startTime))
            let minutes = interval / 60
            let seconds = interval % 60
            self?.callDuration = String(format: "%02d:%02d", minutes, seconds)
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func showError(message: String) {
        errorMessage = message
        showError = true
    }
}

// MARK: - Agora Delegate
extension AgoraViewModel: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        remoteUserId = uid
        callState = .connected

        let remoteView = UIView()
        remoteVideoView = remoteView
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = remoteView
        videoCanvas.renderMode = .fit
        agoraKit?.setupRemoteVideo(videoCanvas)
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        remoteVideoView = nil
        callState = .ended
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        showError(message: "Agora Error: \(errorCode.description)")
    }
}

// MARK: - Error Descriptions
extension AgoraErrorCode {
    var description: String {
        switch self {
        case .joinChannelRejected: return "Join rejected"
        case .leaveChannelRejected: return "Leave rejected"
        case .invalidAppId: return "Invalid App ID"
        case .invalidToken: return "Invalid token"
        default: return "Error code: \(rawValue)"
        }
    }
}

