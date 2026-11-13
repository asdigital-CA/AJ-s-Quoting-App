//
//  Item.swift
//  AJ's Quoting App V2 Beta
//
//  Created by Alex Schmidt on 2025-07-17.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
