//
//  ReminderEntry.swift
//  UVIO
//
//  Created by Macostik on 22.06.2022.
//

import Foundation
import RealmSwift

class ReminderEntry: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var reminderValue: String = ""
    @Persisted var note: String = ""
}
