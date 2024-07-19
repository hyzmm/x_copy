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
    @Environment(\.dataModel) private var dataModel

    var body: some View {
        HStack {
            Text(item.stringContent.trimmingCharacters(in: .whitespacesAndNewlines))
                .lineLimit(1)
                .font(.system(size: 14))
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
            dataModel.copy(index)
        }
    }
}

#Preview {
    ListItem(item: Item(stringContent: "Hello World!", date: Date()), index: 1).frame(width: 200)
}
