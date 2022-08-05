//
//  ReminderEntry.swift
//  UVIO
//
//  Created by Macostik on 22.06.2022.
//

import Foundation
import RealmSwift
import SwiftUI

class ReminderEntry: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var reminderValue: String = ""
    @Persisted var note: String = ""
    @Persisted var createdAt: Date = Date()
}

extension ReminderEntry: Mapable {
    func map() -> ListViewEntry {
        var listViewEntry = ListViewEntry()
        listViewEntry.createdAt = createdAt.convertToString()
        listViewEntry.addedAt = createdAt
        listViewEntry.mainColor = Color.grayBackgroundColor.opacity(0.7)
        listViewEntry.image = Image.bellIcon
        listViewEntry.title =
        Text("\(createdAt.time)")
            .foregroundColor(Color.black)
            .font(.poppins(.bold, size: 12))
        listViewEntry.subTitle =
        Text(L10n.reminder)
            .foregroundColor(Color.black)
            .font(.poppins(.medium, size: 12))
        listViewEntry.timer =
        Text("\(createdAt.time)")
            .font(.poppins(.medium, size: 10))
        listViewEntry.hasCommit = !note.isEmpty
        listViewEntry.note = Text(note)
        return listViewEntry
    }
}
