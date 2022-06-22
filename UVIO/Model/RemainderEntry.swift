//
//  RemainderEntry.swift
//  UVIO
//
//  Created by Macostik on 22.06.2022.
//

import Foundation
import RealmSwift

class RemainderEntry: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var remainderValue: String
    @Persisted var note: String
}
