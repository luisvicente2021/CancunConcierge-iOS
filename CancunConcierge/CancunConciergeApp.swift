//
//  CancunConciergeApp.swift
//  CancunConcierge
//
//  Created by usuario on 13/10/26.
//

import SwiftUI
import FirebaseCore

@main
struct CancunConciergeApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
