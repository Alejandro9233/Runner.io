//
//  ProfileHeaderView.swift
//  Runner.io
//

import SwiftUI

struct ProfileHeaderView: View {
    let userName: String
    let userEmail: String

    var body: some View {
        HStack(spacing: 40) {
            
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(userName)
                    .font(.title)
                    .fontWeight(.bold)
                Text(userEmail)
                    .font(.subheadline)
                .foregroundColor(.gray)}
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background((Color(.white)))
        }
    }


#Preview {
    ProfileHeaderView(userName: "John Doe", userEmail: "johndoe@example.com")
}
