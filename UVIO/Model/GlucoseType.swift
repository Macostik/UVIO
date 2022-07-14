//
//  GlucoseType.swift
//  UVIO
//
//  Created by Macostik on 27.05.2022.
//

import Foundation

class GlucoseType: Equatable {
    let id: Int
    let type: String
    var isSelected: Bool
    init(id: Int, type: String, isSelected: Bool) {
        self.id = id
        self.type = type
        self.isSelected = isSelected
    }
    static func == (lhs: GlucoseType, rhs: GlucoseType) -> Bool {
        lhs.id != rhs.id
    }
}
class UnitsType {
    let id: Int
    let type: String
    var isSelected: Bool
    init(id: Int, type: String, isSelected: Bool) {
        self.id = id
        self.type = type
        self.isSelected = isSelected
    }
}
 var unitsList = [
    UnitsType(id: 1, type: L10n.us, isSelected: true),
    UnitsType(id: 2, type: L10n.metric, isSelected: false)
]
