//
//  GenderType.swift
//  UVIO
//
//  Created by Macostik on 27.05.2022.
//

import Foundation

class GenderType {
    let id: Int
    let type: String
    var isSelected = false
    init(id: Int, type: String, isSelected: Bool) {
        self.id = id
        self.type = type
        self.isSelected = isSelected
    }
}
 var genderTypeList = [
    GenderType(id: 1, type: L10n.female, isSelected: false),
    GenderType(id: 2, type: L10n.male, isSelected: false),
    GenderType(id: 3, type: L10n.nonBinary, isSelected: false),
    GenderType(id: 4, type: L10n.other, isSelected: false)
]
