//
//  Item.swift
//  x_copy
//
//  Created by WengXiang on 2024/7/11.
//

import Foundation
import SwiftData

@Model
final class Item {
    var stringContent: String

    init(_ str: String) {
        self.stringContent = str
    }
}
