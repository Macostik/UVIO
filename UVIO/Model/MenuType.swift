//
//  MenuType.swift
//  UVIO
//
//  Created by Macostik on 09.06.2022.
//

import Foundation
import SwiftUI

enum MenuAction: CaseIterable {
    case logBG, reminder, food, insulin
}

enum InsulinAction: StringLiteralType, CaseIterable {
    case rapid, long
}

class MenuType {
    let id: Int
    let title: String
    var icon: Image
    var shadowColor: Color
    var menuAction: MenuAction
    init(id: Int,
         title: String,
         icon: Image,
         shadowColor: Color,
         menuAction: MenuAction) {
        self.id = id
        self.title = title
        self.icon = icon
        self.shadowColor = shadowColor
        self.menuAction = menuAction
    }
}
 var menuTypeList = [
    MenuType(id: 1,
             title: L10n.logBG,
             icon: Image.bgLevelIcon,
             shadowColor: .red.opacity(0.2),
             menuAction: .logBG),
    MenuType(id: 2,
             title: L10n.addReminder,
             icon: Image.remainderIcon,
             shadowColor: .blue.opacity(0.2),
             menuAction: .reminder),
    MenuType(id: 3,
             title: L10n.logFood,
             icon: Image.foodIcon,
             shadowColor: .yellow.opacity(0.2),
             menuAction: .food),
    MenuType(id: 4,
             title: L10n.logInsulin,
             icon: Image.rapidInsulinIcon,
             shadowColor: .orange.opacity(0.2),
             menuAction: .insulin)
]
