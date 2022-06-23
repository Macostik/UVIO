//
//  InsulinEntry.swift
//  UVIO
//
//  Created by Macostik on 22.06.2022.
//

import Foundation
import RealmSwift

class InsulineEntry: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var insulinValue: String = ""
    @Persisted var date: Date = Date()
    @Persisted var time: Date = Date()
    @Persisted var note: String = ""
}
