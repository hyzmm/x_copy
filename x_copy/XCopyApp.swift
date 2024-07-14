//
//  x_copyApp.swift
//  x_copy
//
//  Created by WengXiang on 2024/7/11.
//

import SwiftData
import SwiftUI

@main
struct XCopyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView().frame(width: 200, height: 300)
        }
        .modelContainer(sharedModelContainer)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            window.titlebarAppearsTransparent = true
            window.backgroundColor = .clear
            window.isOpaque = false
            window.styleMask = [.borderless, .resizable, .miniaturizable]
        }
    }
}
