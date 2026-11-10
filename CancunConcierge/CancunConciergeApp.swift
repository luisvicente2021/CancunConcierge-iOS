//
//  CancunConciergeApp.swift
//  CancunConcierge
//
//  Created by usuario on 13/10/26.
//


import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseFunctions

@main
struct CancunConciergeApp: App {

    init() {
        FirebaseApp.configure()

        #if DEBUG
        let emulatorHost = "192.168.22.11"

        Auth.auth().useEmulator(
            withHost: emulatorHost,
            port: 9099
        )

        let firestore = Firestore.firestore()

        let settings = firestore.settings
        settings.host = "\(emulatorHost):8080"
        settings.isSSLEnabled = false
        firestore.settings = settings

        Functions.functions().useEmulator(
            withHost: emulatorHost,
            port: 5001
        )
        #endif
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
