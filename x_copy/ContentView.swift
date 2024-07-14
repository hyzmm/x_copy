//
//  ContentView.swift
//  x_copy
//
//  Created by WengXiang on 2024/7/11.
//

import Combine
import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var clipboardPublisher: AnyCancellable?
    @State private var changeCount = 0

    var body: some View {
        List {
            ForEach(items) { item in
                ListItem(item: item)
            }
            .onDelete(perform: deleteItems)
            .listRowBackground(Color.clear)
        }
        .scrollContentBackground(.hidden)
        .onAppear {
            startListeningToClipboard()
        }
        .background(VisualEffectView())
    }

    func startListeningToClipboard() {
        changeCount = NSPasteboard.general.changeCount
        clipboardPublisher = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                let newChangeCount = NSPasteboard.general.changeCount
                if newChangeCount != changeCount {
                    if let str = NSPasteboard.general.string(forType: .string) {
                        addItem(str: str)
                    }
                    changeCount = newChangeCount
                }
            }
    }

    private func addItem(str: String) {
        let newItem = Item(str)
        modelContext.insert(newItem)
    }

    private func deleteItems(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(items[index])
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Item.self, configurations: config)

    container.mainContext.insert(Item("Hello World!"))
    container.mainContext.insert(
        Item(
            // swiftlint:disable:next line_length
            "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit"
        ))

    return ContentView()
        .modelContainer(container)
        .frame(width: 200, height: 300)
}
