//
//  TopAlignedScrollView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 14/07/2025.
import Foundation
import SwiftUI
import FirebaseFunctions

struct TopAlignedScrollView<Content: View>: View {
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack {
                    Color.clear
                        .frame(height: 0)
                        .id("topAnchor")
                    
                    content()
                }
            }
            .onAppear {
                proxy.scrollTo("topAnchor", anchor: .top)
            }
        }
    }
}
