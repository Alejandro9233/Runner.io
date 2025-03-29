//
//  ProfileHeaderView.swift
//  Runner.io
//

import SwiftUI

struct ProfileHeaderView: View {
    let userName: String
    let userEmail: String

    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
                .padding(.bottom, 10)

            Text(userName)
                .font(.title)
                .fontWeight(.bold)

            Text(userEmail)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}
