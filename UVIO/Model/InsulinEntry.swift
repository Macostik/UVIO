//
//  InsulinEntry.swift
//  UVIO
//
//  Created by Macostik on 22.06.2022.
//

import Foundation
import RealmSwift
import SwiftUI

class InsulinEntry: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var insulinValue: String = ""
    @Persisted var date: Date = Date()
    @Persisted var time: Date = Date()
    @Persisted var note: String = ""
    @Persisted var createdAt: Date = Date()
    @Persisted var action: String = ""
}

extension InsulinEntry: Mapable {
    var isRapidAction: Bool {
        action == InsulinAction.rapid.rawValue
    }
    var color: Color {
        isRapidAction  ?
        Color.rapidOrangeColor.opacity(0.1) :
        Color.longInsulinColor.opacity(0.1)
    }
    var image: Image {
        isRapidAction ?
        Image.rapidInsulinIcon :
        Image.longInsulinIcon
    }
    func map() -> ListViewEntry {
        var listViewEntry = ListViewEntry()
        listViewEntry.createdAt = createdAt.convertToString()
        listViewEntry.addedAt = createdAt
        listViewEntry.mainColor = color
        listViewEntry.image = image
        listViewEntry.title =
        Text(L10n.insulinLog)
            .foregroundColor(Color.black)
            .font(.poppins(.bold, size: 12))
        listViewEntry.subTitle =
        Text("\(insulinValue) " + "units")
            .font(.poppins(.medium, size: 12))
        listViewEntry.action =
        Text("\(action)")
            .font(.poppins(.medium, size: 10))
        listViewEntry.timer =
        Text("\(createdAt.time)")
            .font(.poppins(.medium, size: 10))
        return listViewEntry
    }
}
