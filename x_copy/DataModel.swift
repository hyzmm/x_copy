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

@Observable class DataModel: ObservableObject {
    var records: [Item] = []

    func addRecord(content: String) {
        records.append(Item(stringContent: content, date: Date()))
        if records.count > 100 {
            records.removeFirst()
        }
    }

    func deleteRecord(_ at: Int) {
        records.remove(at: at)
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
