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
    @Environment(\.dataModel) private var dataModel
    @EnvironmentObject private var copyNotification: CopyNotification
    @State private var clipboardPublisher: AnyCancellable?
    @State private var changeCount = 0

    var body: some View {
        List {
            ForEach(dataModel.records.reversed()) { item in
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
                        // Copy behavior will trigger this code, we need this check to avoid redundant calls.
                        if str != copyNotification.lastCopy && str != dataModel.records.last?.stringContent {
                            addItem(str: str)
                        }
                    }
                    changeCount = newChangeCount
                }
            }
    }

    private func addItem(str: String) {
        dataModel.addRecord(content: str)
    }

    private func deleteItems(offsets: IndexSet) {
        for index in offsets {
            dataModel.deleteRecord(index)
        }
    }
}

#Preview {
    let dataModel = DataModel()
    dataModel.addRecord(content: "Hello World!")
    dataModel.addRecord(content: // swiftlint:disable:next line_length
        "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit")
    return ContentView()
        .environment(dataModel)
        .frame(width: 200, height: 300)
}
