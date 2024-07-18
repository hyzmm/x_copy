//

//  ListItem.swift
//  x_copy
//
//  Created by WengXiang on 2024/7/14.
//

import SwiftUI

struct ListItem: View {
    var item: Item
    var index: Int
    @State var hover: Bool = false
    @Environment(\.dataModel) private var dataModel

    var body: some View {
        HStack {
            Text(item.stringContent.trimmingCharacters(in: .whitespacesAndNewlines))
                .lineLimit(1)
                .font(.system(size: 14))
                .scaleEffect(hover ? 1 : 0.9, anchor: .leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            if index < 9 {
                VStack {
                    Text("\(index + 1)")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .monospacedDigit()
                }
                .frame(width: 16, height: 16)
                .background(Color.secondary.cornerRadius(3))
            }
        }
        .onTapGesture {
            dataModel.copy(item.stringContent)
        }
        .onHover(perform: { hovering in
            withAnimation {
                hover = hovering
            }
        })
    }
}

#Preview {
    ListItem(item: Item(stringContent: "Hello World!", date: Date()), index: 1).frame(width: 200)
}
