//
//  InsulinEntry.swift
//  UVIO
//
//  Created by Macostik on 22.06.2022.
//

import Foundation
import RealmSwift
import SwiftUI

class InsulinEntry: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var insulinValue: String = ""
    @Persisted var date: Date = Date()
    @Persisted var time: Date = Date()
    @Persisted var note: String = ""
    @Persisted var createdAt: Date = Date()
    @Persisted var action: String = ""
}

extension InsulinEntry: Mapable {
    func map() -> ListViewEntry {
        var listViewEntry = ListViewEntry()
        listViewEntry.createdAt = createdAt.convertToString()
        listViewEntry.image =
        Image.rapidInsulinIcon
        listViewEntry.type =
        Text(L10n.logInsulin)
            .foregroundColor(Color.black)
            .font(.poppins(.bold, size: 12))
        listViewEntry.value =
        Text("\(insulinValue) " + "units")
            .foregroundColor(Color.primaryGreenColor)
            .font(.poppins(.bold, size: 16))
        listViewEntry.action =
        Text("\(action)")
            .font(.poppins(.medium, size: 10))
        listViewEntry.timer =
        Text("\(createdAt.time)")
            .font(.poppins(.medium, size: 10))
        return listViewEntry
    }
}
