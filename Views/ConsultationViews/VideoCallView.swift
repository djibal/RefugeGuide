//
//  VideoCallView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 15/06/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
import AgoraRtcKit
import SwiftUICore

struct VideoCallView: View {
    @ObservedObject var vm: VideoConsultationViewModel
    
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")

    var body: some View {
        ZStack {
            // Remote video
            AgoraVideoView(view: vm.remoteVideoView)
                .edgesIgnoringSafeArea(.all)

            // Local video preview
            AgoraVideoView(view: vm.localVideoView)
                .frame(width: 100, height: 150)
                .cornerRadius(8)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)

            // Call Controls
            VStack {
                Spacer()
                HStack(spacing: 40) {
                    Button(action: vm.toggleMute) {
                        Image(systemName: vm.isMuted ? "mic.slash.fill" : "mic.fill")
                            .padding()
                            .background(Circle().fill(Color.gray.opacity(0.7)))
                            .foregroundColor(.white)
                            .background(AppColors.primary)
                    }

                    Button(action: vm.endCall) {
                        Image(systemName: "phone.down.fill")
                            .padding()
                            .background(Circle().fill(Color.red))
                            .foregroundColor(.white)
                            .background(AppColors.primary)
                    }
                }
                .padding()
            }
        }
    }
}

struct AgoraVideoView: UIViewRepresentable {
    let view: UIView?

    func makeUIView(context: Context) -> UIView {
        return view ?? UIView()
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

