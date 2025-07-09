//
//  VideoConsultationView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 15/06/2025.

import SwiftUI
import AgoraRtcKit

struct VideoConsultationView: View {
    @StateObject private var agoraVM = AgoraViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    let consultation: Consultation

    var body: some View {
        ZStack {
            // Video grid
            AgoraVideoGrid(viewModel: agoraVM)

            // Controls overlay
            VStack {
                CallHeader(viewModel: agoraVM)
                Spacer()
                CallControls(viewModel: agoraVM) 
            }
        }
        .onAppear { agoraVM.joinChannel() }
        .onDisappear { agoraVM.leaveChannel() }
        .alert(isPresented: $agoraVM.showError) {
            Alert(
                title: Text("Connection Error"),
                message: Text(agoraVM.errorMessage),
                dismissButton: .default(Text("OK")) {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

// MARK: - Agora Video Grid

private struct AgoraVideoGrid: View {
    @ObservedObject var viewModel: AgoraViewModel

    var body: some View {
        ZStack {
            // Remote video
            if let remoteView = viewModel.remoteVideoView {
                AgoraVideoView(view: remoteView)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Color.black
                ProgressView("Connecting to legal advisor...")
                    .padding(.bottom, 100)
            }

            // Local preview
            if let localView = viewModel.localVideoView {
                AgoraVideoView(view: localView)
                    .frame(width: 120, height: 160)
                    .cornerRadius(8)
                    .padding(.top, 10)
                    .padding(.trailing, 10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            }
        }
    }
}

// MARK: - UIViewRepresentable for Agora video rendering
     // Renamed 
struct AgoraUserVideoView: UIViewRepresentable {
    let view: UIView

    func makeUIView(context: Context) -> UIView {
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

// MARK: - Header

private struct CallHeader: View {
    @ObservedObject var viewModel: AgoraViewModel

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.callState.description).font(.caption).foregroundColor(.white)
                Text("Advisor: \(viewModel.advisorName)").font(.headline).foregroundColor(.white)
                Text("Duration: \(viewModel.callDuration)").font(.caption).foregroundColor(.white)
            }
            Spacer()
            Button(action: viewModel.toggleCamera) {
                Image(systemName: viewModel.isVideoEnabled ? "video" : "video.slash")
                    .padding(8)
                    .background(viewModel.isVideoEnabled ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .clipShape(Circle())
            }
        }
        .padding()
        .background(Color.black.opacity(0.5))
    }
}

// MARK: - Controls

private struct CallControls: View {
    @ObservedObject var viewModel: AgoraViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        HStack(spacing: 40) {
            Button(action: viewModel.toggleMic) {
                CallControlButton(icon: viewModel.isAudioEnabled ? "mic.fill" : "mic.slash.fill", bgColor: viewModel.isAudioEnabled ? .blue : .gray)
            }

            Button(action: endCall) {
                CallControlButton(icon: "phone.down.fill", bgColor: .red).scaleEffect(1.2)
            }

            Button(action: viewModel.toggleSpeaker) {
                CallControlButton(icon: viewModel.isSpeakerOn ? "speaker.wave.2.fill" : "speaker.slash.fill", bgColor: viewModel.isSpeakerOn ? .blue : .gray)
            }
        }
        .padding(.bottom, 50)
    }

    private func endCall() {
        viewModel.leaveChannel()
        presentationMode.wrappedValue.dismiss()
    }
}

private struct CallControlButton: View {
    let icon: String
    let bgColor: Color

    var body: some View {
        Image(systemName: icon)
            .font(.title)
            .padding(20)
            .background(bgColor)
            .foregroundColor(.white)
            .clipShape(Circle())
    }
}


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

        // Setup video configuration
        let videoConfig = AgoraVideoEncoderConfiguration(
            size: AgoraVideoDimension640x360,
            frameRate: .fps15,
            bitrate: AgoraVideoBitrateStandard,
            orientationMode: .adaptative,
            mirrorMode: .auto
        )

        agoraKit?.setVideoEncoderConfiguration(videoConfig)
        
        // Enable audio features
        agoraKit?.enableAudio()
        agoraKit?.setDefaultAudioRouteToSpeakerphone(true)
    }
    
    func joinChannel() {
        guard let channelId = UserDefaults.standard.string(forKey: "legalChannelId") else {
            showError(message: "No channel configured")
            return
        }
        
        let uid: UInt = 0 // Let Agora assign UID
        agoraKit?.joinChannel(
            byToken: nil,
            channelId: channelId,
            info: nil,
            uid: uid,
            joinSuccess: nil
        )
        
        // Setup local video
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

extension AgoraViewModel: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        remoteUserId = uid
        callState = .connected
        
        // Setup remote video
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
#if DEBUG
struct VideoConsultationView_Previews: PreviewProvider {
    static var previews: some View {
        VideoConsultationView(consultation: Consultation.mock)
    }
}
#endif

#if DEBUG
extension Consultation {
    static let mock = Consultation(
        id: "demo123",
        date: Date(),
        type: .legal,
        status: .scheduled,
        specialistID: "mockSpecialist",
        notes: "Bring ID and documents",
        createdAt: nil
    )
}
#endif
