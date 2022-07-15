//
//  ListViewEntry.swift
//  UVIO
//
//  Created by Macostik on 23.06.2022.
//

import Foundation
import SwiftUI
import RealmSwift

protocol Mapable {
    func map() -> ListViewEntry
}

struct ListItem: Hashable {
    let index: Int
    let keyObject: String
    let valueObjects: [ListViewEntry]
    var color = Color.clear
}

struct ListViewEntry: Hashable {
    var id = UUID().uuidString
    var createdAt = ""
    var image = Image("")
    var mainColor = Color.grayScaleColor
    var title = Text("")
    var subTitle = Text("")
    var action: Text?
    var note = Text("")
    var timer = Text("")
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
