//
//  GlucoseType.swift
//  UVIO
//
//  Created by Macostik on 27.05.2022.
//

import Foundation

class GlucoseType {
    let id: Int
    let type: String
    var isSelected: Bool
    init(id: Int, type: String, isSelected: Bool) {
        self.id = id
        self.type = type
        self.isSelected = isSelected
    }
}
 var glucoseTypeList = [
    GlucoseType(id: 1, type: L10n.mgDL, isSelected: true),
    GlucoseType(id: 2, type: L10n.mmolL, isSelected: false)
]
