//
//  FoodEntry.swift
//  UVIO
//
//  Created by Macostik on 22.06.2022.
//

import Foundation
import RealmSwift
import SwiftUI

class FoodEntry: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var carbsValue: String = ""
    @Persisted var foodName: String = ""
    @Persisted var date: Date = Date()
    @Persisted var time: Date = Date()
    @Persisted var createdAt: Date = Date()
    @Persisted var note: String = ""
}

extension FoodEntry: Mapable {
    var carbsIntValue: String {
        String(carbsValue.split(separator: " ").first ?? "")
    }
    func map() -> ListViewEntry {
        var listViewEntry = ListViewEntry()
        listViewEntry.createdAt = createdAt.convertToString()
        listViewEntry.addedAt = createdAt
        listViewEntry.image = Image.foodEntryIcon
        listViewEntry.mainColor = Color.primaryFoodColor
        listViewEntry.title =
        Text(L10n.foodLog)
            .foregroundColor(Color.black)
            .font(.poppins(.bold, size: 12))
        listViewEntry.subTitle =
        Text("\(foodName)")
            .foregroundColor(Color.black)
            .font(.poppins(.medium, size: 12))
        listViewEntry.action =
        Text("Carbs - \(carbsIntValue) g")
            .font(.poppins(.medium, size: 10))
        listViewEntry.timer =
        Text("\(createdAt.time)")
        listViewEntry.hasCommit = !note.isEmpty
        listViewEntry.note = Text(note)
        return listViewEntry
    }
}
