//
//  PostArcApp.swift
//  PostArc
//
//  Created by Yixuan Liu on 8/12/24.
//

import SwiftUI

@main
struct PostArcApp: App {
    @StateObject private var postcardData = PostcardData()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(postcardData) // Inject PostcardData into the environment
        }
    }
}
