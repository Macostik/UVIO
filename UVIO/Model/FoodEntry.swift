//
//  FoodEntry.swift
//  UVIO
//
//  Created by Macostik on 22.06.2022.
//

import Foundation
import RealmSwift
import SwiftUI

class FoodEntry: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var carbsValue: String = ""
    @Persisted var foodName: String = ""
    @Persisted var date: Date = Date()
    @Persisted var time: Date = Date()
    @Persisted var createdAt: Date = Date()
    @Persisted var note: String = ""
}

extension FoodEntry: Mapable {
    func map() -> ListViewEntry {
        var listViewEntry = ListViewEntry()
        listViewEntry.createdAt = createdAt.convertToString()
        listViewEntry.image = Image.foodIcon
        listViewEntry.type =
        Text(L10n.logFood)
            .foregroundColor(Color.black)
            .font(.poppins(.bold, size: 12))
        listViewEntry.value =
        Text("\(carbsValue)")
            .foregroundColor(Color.black)
            .font(.poppins(.bold, size: 10))
        listViewEntry.action =
        Text("Carbs - \(carbsValue)g")
            .font(.poppins(.medium, size: 10))
        listViewEntry.timer =
        Text("\(createdAt.time)")
        return listViewEntry
    }
}
