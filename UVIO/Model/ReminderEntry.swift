//
//  ReminderEntry.swift
//  UVIO
//
//  Created by Macostik on 22.06.2022.
//

import Foundation
import RealmSwift
import SwiftUI

class ReminderEntry: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var reminderValue: String = ""
    @Persisted var note: String = ""
}

extension ReminderEntry: Mapable {
    func map() -> ListViewEntry {
        var listViewEntry = ListViewEntry()
        listViewEntry.image = Image.rapidInsulinIcon
        listViewEntry.type =
        Text("BG level log")
            .foregroundColor(Color.black)
            .font(.poppins(.bold, size: 12))
        listViewEntry.value =
        Text("\(reminderValue)")
            .foregroundColor(Color.primaryGreenColor)
            .font(.poppins(.bold, size: 16))
        return listViewEntry
    }
}
