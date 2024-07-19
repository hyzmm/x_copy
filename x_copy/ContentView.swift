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
    @State private var clipboardPublisher: AnyCancellable?
    @FocusState private var focued: Bool

    var body: some View {
        let selection: Binding<Int> = Binding(get: { dataModel.selectionIndex }, set: { value in self.dataModel.selectionIndex = value })

        List(selection: selection) {
            ForEach(Array(dataModel.records.reversed().enumerated()), id: \.offset) { index, item in
                ListItem(item: item, index: index)
                    .onHover(perform: { hovering in
                        withAnimation {
                            if hovering {
                                dataModel.selectionIndex = index
                            }
                        }
                    })
            }
            .onDelete(perform: deleteItems)
        }
        .scrollContentBackground(.hidden)
        .onAppear {
            startListeningToClipboard()
        }
        .background(VisualEffectView())
        .focusable()
        .focused($focued)
        .onKeyPress(keys: ["1", "2", "3", "4", "5", "6", "7", "8", "9"]) { press in
            let index = dataModel.records.count - Int(press.characters)!
            copy(index)
            return .handled
        }
        .onAppear {
            focued = true
        }
    }

    func copy(_ index: Int) {
        guard index < dataModel.records.count else {
            return
        }
        dataModel.copy(index)
    }

    func startListeningToClipboard() {
        dataModel.changeCount = NSPasteboard.general.changeCount

        clipboardPublisher = Timer.publish(every: 0.016, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                let newChangeCount = NSPasteboard.general.changeCount
                if newChangeCount != dataModel.changeCount {
                    if dataModel.isAppInitiatedCopy {
                        dataModel.isAppInitiatedCopy = false
                    } else {
                        if let str = NSPasteboard.general.string(forType: .string) {
                            // Copy behavior will trigger this code, we need this check to avoid redundant calls.
                            if str != dataModel.records.last?.stringContent {
                                addItem(str: str)
                            }
                        }
                    }
                    dataModel.changeCount = newChangeCount
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
    dataModel.addRecord(content:
        // swiftlint:disable:next line_length
        "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit")
    return ContentView()
        .environment(dataModel)
        .frame(width: 200, height: 300)
}
