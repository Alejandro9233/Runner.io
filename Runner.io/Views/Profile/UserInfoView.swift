//
//  UserInfoView.swift
//  Runner.io
//

import SwiftUI

struct UserInfoView: View {
    let userEmail: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Statistics")
                .font(.headline)
            
            HStack(spacing: 40) {
                VStack(spacing: -2) {
                    Text("2.33")
                    Text("Kilometers")
                        .font(.caption)
                }
                VStack(spacing: -2) {
                    Text("10.5k")
                    Text("Calories")
                        .font(.caption)
                }
                VStack(spacing: -2) {
                    Text("32km")
                    Text("Territory")
                        .font(.caption)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background((Color(.white)))

    }
}
#Preview {
    UserInfoView(userEmail: "anapfigueroatgmail.com")
}
