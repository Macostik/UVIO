//
//  LogBGEntry.swift
//  UVIO
//
//  Created by Macostik on 22.06.2022.
//

import Foundation
import RealmSwift

class LogBGEntry: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var value: String = ""
    @Persisted var date: Date = Date()
    @Persisted var time: Date = Date()
    @Persisted var note: String = ""
}
