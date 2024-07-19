//
//  DataModel.swift
//  x_copy
//
//  Created by WengXiang on 2024/7/14.
//

import Foundation
import SwiftUI

@Observable class Item: Identifiable {
    var stringContent: String
    var date: Date

    init(stringContent: String, date: Date) {
        self.stringContent = stringContent
        self.date = date
    }
}

@Observable class DataModel {
    var records: [Item] = []
    var selectionIndex: Int?

    @ObservationIgnored var isAppInitiatedCopy: Bool = false
    @ObservationIgnored var changeCount: Int = 0

    func copy(_ index: Int) {
        isAppInitiatedCopy = true
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setData(records[index].stringContent.data(using: .utf8), forType: .string)

        selectionIndex = index
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            NotificationCenter.default.post(name: .CloseStatusBarPopup, object: nil)
            self.selectionIndex = nil
        }
    }

    func addRecord(content: String) {
        records.append(Item(stringContent: content, date: Date()))
        if records.count > 100 {
            records.removeFirst()
        }
    }

    func deleteRecord(_ index: Int) {
        records.remove(at: index)
    }
}

extension EnvironmentValues {
    var dataModel: DataModel {
        get { self[DataModelKey.self] }
        set { self[DataModelKey.self] = newValue }
    }
}

private struct DataModelKey: EnvironmentKey {
    static var defaultValue: DataModel = .init()
}
