//
//  VideoCallView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 15/06/2025.
//

import SwiftUI

struct VideoCallView: View {
    @ObservedObject var vm: VideoConsultationViewModel

    var body: some View {
        ZStack {
            // Remote video
            AgoraVideoCanvas(view: vm.remoteVideoView)
                .edgesIgnoringSafeArea(.all)

            // Local video preview
            AgoraVideoCanvas(view: vm.localVideoView)
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
                    }

                    Button(action: vm.endCall) {
                        Image(systemName: "phone.down.fill")
                            .padding()
                            .background(Circle().fill(Color.red))
                            .foregroundColor(.white)
                    }
                }
                .padding()
            }
        }
    }
}
