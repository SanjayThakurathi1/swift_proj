//
//  Item.swift
//  AlaramPing
//
//  Created by sanjay Thakurathi on 26/02/2024.
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
