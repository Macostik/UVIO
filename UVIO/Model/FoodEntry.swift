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
    @Persisted var note: String = ""
}

extension FoodEntry: Mapable {
    func map() -> ListViewEntry {
        var listViewEntry = ListViewEntry()
        listViewEntry.image = Image.foodIcon
        listViewEntry.type =
        Text("BG level log")
            .foregroundColor(Color.black)
            .font(.poppins(.bold, size: 12))
        listViewEntry.value =
        Text("\(carbsValue)")
            .foregroundColor(Color.primaryGreenColor)
            .font(.poppins(.bold, size: 16))
        return listViewEntry
    }
}
