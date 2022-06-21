//
//  CrabsType.swift
//  UVIO
//
//  Created by Macostik on 21.06.2022.
//

import Foundation

enum CarbsPickerData: StringLiteralType, CaseIterable {
    case c15, c30, c45, c60, c75, c90
    var description: String {
        switch self {
        case .c15: return "15 carbs"
        case .c30: return "30 carbs"
        case .c45: return "45 carbs"
        case .c60: return "60 carbs"
        case .c75: return "75 carbs"
        case .c90: return "90 carbs"
        }
    }
}
