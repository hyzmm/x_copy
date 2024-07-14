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
    @State var statusBarController: StatusBarController?
    @StateObject var dataModel: DataModel = .init()
    @StateObject var copyNotification: CopyNotification = .init()

    var body: some Scene {
        WindowGroup {
            ContentView().frame(width: 200, height: 300)
                .onAppear {
                    print("appear")
                    if let window = NSApplication.shared.windows.first {
                        window.titlebarAppearsTransparent = true
                        window.backgroundColor = .clear
                        window.isOpaque = false
                        window.styleMask = [.borderless, .resizable, .miniaturizable]
                    }
                    statusBarController = StatusBarController(dataModel: dataModel, copyNotification: copyNotification)
                }
                .environment(dataModel)
                .environmentObject(copyNotification)

        }
    }
}
