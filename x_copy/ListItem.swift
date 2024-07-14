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

    var body: some View {
        Text(item.stringContent)
            .lineLimit(1)
            .onTapGesture {
                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setData(item.stringContent.data(using: .utf8), forType: .string)
            }
            .onHover(perform: { hovering in
                withAnimation {
                    hover = hovering
                }
            })
            .font(.system(size: 14))
            .scaleEffect(hover ? 1 : 0.9, anchor: .leading)
    }
}

#Preview {
    ListItem(item: Item("Hello World!"))
}
