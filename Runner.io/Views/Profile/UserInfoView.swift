//
//  UserInfoView.swift
//  Runner.io
//

import SwiftUI

struct UserInfoView: View {
    let userEmail: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Account Information")
                .font(.headline)

            HStack {
                Image(systemName: "envelope.fill")
                    .foregroundColor(.blue)
                Text(userEmail)
                    .font(.subheadline)
            }

            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.blue)
                Text("Member since: January 2025") // Replace with dynamic data if available
                    .font(.subheadline)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
    }
}
