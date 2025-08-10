//
//  ServiceRow.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 17/06/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
<<<<<<< HEAD
import SwiftUICore
=======
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf

struct ServiceRow: View {
    let service: LocalService

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(service.name)
                    .font(.headline)
                Text(service.category)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            if let discount = service.discount {
                Text("\(discount)% OFF")
                    .padding(5)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
        }
    }
}
