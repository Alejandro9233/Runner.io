//
//  MapView.swift
//  Runner.io
//
//  Created by Alejandro  on 19/01/25.
//

import SwiftUI

struct MapView: View {
    
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    MapView(userId: "")
}
