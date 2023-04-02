//
//  CPU_MApp.swift
//  CPU-M
//
//  Created by Nikita Schneider on 02.04.2023.
//

import SwiftUI


struct VisualEffect: NSViewRepresentable {
    func makeNSView(context: Self.Context) -> NSView {
        let effect = NSVisualEffectView()
        effect.state = NSVisualEffectView.State.active
        return effect
    }
    func updateNSView(_ nsView: NSView, context: Context) { }
}

@main
struct CPU_MApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                
        }.windowResizability(.contentSize)
            .windowToolbarStyle(UnifiedCompactWindowToolbarStyle())
            .windowStyle(HiddenTitleBarWindowStyle())
    }
}
