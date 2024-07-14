//
//  ListItem.swift
//  x_copy
//
//  Created by WengXiang on 2024/7/14.
//

import SwiftUI

struct ListItem: View {
    var item: Item
    @State var hover: Bool = false
    @EnvironmentObject var copyNotification: CopyNotification

    var body: some View {
        Text(item.stringContent.trimmingCharacters(in: .whitespacesAndNewlines))
            .lineLimit(1)
            .font(.system(size: 14))
            .scaleEffect(hover ? 1 : 0.9, anchor: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .onTapGesture {
                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setData(item.stringContent.data(using: .utf8), forType: .string)
                copyNotification.trigger(item.stringContent)
            }
            .onHover(perform: { hovering in
                withAnimation {
                    hover = hovering
                }
            })
    }
}

#Preview {
    ListItem(item: Item(stringContent: "Hello World!", date: Date()))
}
