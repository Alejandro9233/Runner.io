//
//  Runner_ioApp.swift
//  Runner.io
//
//  Created by Alejandro  on 19/01/25.
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
