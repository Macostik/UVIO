//
//  LogBGEntry.swift
//  UVIO
//
//  Created by Macostik on 22.06.2022.
//

import Foundation
import RealmSwift
import SwiftUI

class LogBGEntry: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var logValue: String = ""
    @Persisted var date: Date = Date()
    @Persisted var time: Date = Date()
    @Persisted var note: String = ""
}

extension LogBGEntry: Mapable {
    func map() -> ListViewEntry {
        var listViewEntry = ListViewEntry()
        listViewEntry.image = Image.loadIcon
        listViewEntry.type =
        Text("BG level log")
            .foregroundColor(Color.black)
            .font(.poppins(.bold, size: 12))
        listViewEntry.value =
        Text("\(logValue)")
            .foregroundColor(Color.primaryGreenColor)
            .font(.poppins(.bold, size: 16))
        return listViewEntry
    }
}
