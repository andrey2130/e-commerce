//
//  Item.swift
//  Ecommerce
//
//  Created by Andrii Duda on 26.01.2026.
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
