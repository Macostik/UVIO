//
//  LogBGEntry.swift
//  UVIO
//
//  Created by Macostik on 22.06.2022.
//

import Foundation
import RealmSwift
import SwiftUI

class LogBGEntry: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var logValue: String = ""
    @Persisted var logUnitType: String = ""
    @Persisted var date: Date = Date()
    @Persisted var time: Date = Date()
    @Persisted var note: String = ""
    @Persisted var createdAt: Date = Date()
}

extension LogBGEntry: Mapable {
    func map() -> ListViewEntry {
        var listViewEntry = ListViewEntry()
        listViewEntry.createdAt = createdAt.convertToString()
        listViewEntry.addedAt = createdAt
        listViewEntry.mainColor = Color.grayBackgroundColor.opacity(0.7)
        listViewEntry.image = Image.bgLogIcon
        listViewEntry.title =
        Text(L10n.bgLog)
            .foregroundColor(Color.black)
            .font(.poppins(.bold, size: 12))
        listViewEntry.subTitle =
        Text("\(logValue)")
            .foregroundColor(Color.primaryGreenColor)
            .font(.poppins(.bold, size: 16))
            +
        Text(" \(logUnitType)")
            .foregroundColor(Color.black)
            .font(.poppins(.medium, size: 12))
        listViewEntry.timer =
        Text("\(createdAt.time)")
        listViewEntry.hasCommit = !note.isEmpty
        listViewEntry.note = Text(note)
        return listViewEntry
    }
}
