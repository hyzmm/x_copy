//
//  CopyNotification.swift
//  x_copy
//
//  Created by WengXiang on 2024/7/14.
//

import Foundation

class CopyNotification: ObservableObject {
    @Published var lastCopy: String?

    func trigger(_ content: String) {
        lastCopy = content
    }
}
