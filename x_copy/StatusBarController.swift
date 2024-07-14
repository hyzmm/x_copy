import Cocoa
import Combine
import SwiftData
import SwiftUI

class StatusBarController: NSObject {
    private var statusItem: NSStatusItem?
    private var popover: NSPopover?

    private var dataModel: DataModel
    private var copyNotification: CopyNotification

    private var cancellable: AnyCancellable?

    init(dataModel: DataModel, copyNotification: CopyNotification) {
        self.dataModel = dataModel
        self.copyNotification = copyNotification
        super.init()

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "doc.on.doc.fill", accessibilityDescription: "X Copy")
            button.action = #selector(togglePopover)
            button.target = self
        }

        cancellable = copyNotification.objectWillChange.sink { _ in
            self.popover?.close()
        }

        popover = NSPopover()
        popover?.contentSize = NSSize(width: 200, height: 300)
        popover?.behavior = .transient
        popover?.contentViewController = NSHostingController(rootView: ContentView().environment(dataModel).environmentObject(copyNotification))
    }

    @objc func togglePopover() {
        if let button = statusItem?.button {
            if popover?.isShown == true {
                popover?.performClose(nil)
            } else {
                popover?.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
}
