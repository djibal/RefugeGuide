//
//  VideoConsultationView.swift
//  RefugeGuide

//  Created by Djibal Ramazani on 15/06/2025.

import Foundation
import SwiftUI
import FirebaseFunctions
import AgoraRtcKit
import SwiftUICore

struct VideoConsultationView: View {
    let consultation: Consultation  
    @StateObject private var agoraVM = AgoraViewModel()
    @Environment(\.presentationMode) var presentationMode

    
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")

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
        .onAppear {
            agoraVM.joinChannel(for: consultation)
        }

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
                    .background(AppColors.primary)
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
