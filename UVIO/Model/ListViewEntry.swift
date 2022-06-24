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

struct ListViewEntry {
    var image = Image("")
    var type = Text("")
    var value = Text("")
    var action = Text("")
    var note = Text("")
    var timer = Text("")
}
