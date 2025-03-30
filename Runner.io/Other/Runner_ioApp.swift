//
//  Runner_ioApp.swift
//  Runner.io
//
//  Created by Alejandro on 28/03/25.
//

import SwiftUI
import Firebase

@main
struct Runner_ioApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
