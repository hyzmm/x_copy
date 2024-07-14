//
//  WindowExtension.swift
//  x_copy
//
//  Created by WengXiang on 2024/7/14.
//

import AppKit
import SwiftUI

struct VisualEffectView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let effectView = NSVisualEffectView()

        effectView.material = .hudWindow
        effectView.state = .active

        return effectView
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}
