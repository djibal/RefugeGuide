//
//  VideoConsultationView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 15/06/2025.
//

import SwiftUI

struct VideoConsultationView: View {
    @StateObject private var videoVM = VideoConsultationViewModel()
    @StateObject private var scheduleVM = ConsultationScheduleViewModel()

    var body: some View {
        Group {
            if videoVM.inCall {
                VideoCallView(vm: videoVM)
            } else {
                ConsultationListView(
                    consultations: $scheduleVM.consultations,
                    joinCall: videoVM.joinChannel
                )
            }
        }
        .onAppear {
            scheduleVM.fetchConsultations()
        }
    }
}
