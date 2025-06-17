//
//  VideoConsultationViewModel.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 15/06/2025.
//

import Foundation
import AgoraRtcKit
import SwiftUI

   class VideoConsultationViewModel: NSObject, ObservableObject, AgoraRtcEngineDelegate {
       
    @Published var inCall = false
    @Published var isMuted = false

    let localVideoView = UIView()
    let remoteVideoView = UIView()

    private var agoraKit: AgoraRtcEngineKit?

    override init() {
        super.init()
        initializeAgora()
    }

    private func initializeAgora() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: "YOUR_AGORA_APP_ID", delegate: self)
        agoraKit?.enableVideo()
        agoraKit?.setChannelProfile(.communication)

        let localCanvas = AgoraRtcVideoCanvas()
        localCanvas.uid = 0
        localCanvas.view = localVideoView
        localCanvas.renderMode = .hidden
        agoraKit?.setupLocalVideo(localCanvas)
    }

    func joinChannel(channel: String) {
        agoraKit?.joinChannel(byToken: nil, channelId: channel, info: nil, uid: 0) { [weak self] _, _, _ in
            DispatchQueue.main.async {
                self?.inCall = true
            }
        }
    }

    func endCall() {
        agoraKit?.leaveChannel(nil)
        inCall = false
    }

    func toggleMute() {
        isMuted.toggle()
        agoraKit?.muteLocalAudioStream(isMuted)
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        let remoteCanvas = AgoraRtcVideoCanvas()
        remoteCanvas.uid = uid
        remoteCanvas.view = remoteVideoView
        remoteCanvas.renderMode = .fit
        agoraKit?.setupRemoteVideo(remoteCanvas)
    }
}
