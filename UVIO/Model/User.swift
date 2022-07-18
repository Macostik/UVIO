//
//  User.swift
//  UVIO
//
//  Created by Macostik on 19.05.2022.
//

import Foundation
import RealmSwift

class User: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String = ""
    @Persisted var birthDate: Date = Date()
    @Persisted var gender: String = ""
    @Persisted var diabetsType: String = ""
    @Persisted var email: String = ""
    @Persisted var password: String = ""
    @Persisted var glucoseUnit: String = ""
    @Persisted var glucoseTargetLowerBound: Int = 0
    @Persisted var glucoseTargetUpperBound: Int = 0
    @Persisted var hyper: Int = 0
    @Persisted var hypo: Int = 0
    @Persisted var isLogin: Bool = true
    @Persisted var isVibrate: Bool = false
    @Persisted var isNotDisturb: Bool = false
    @Persisted var authToken: String = ""
    @Persisted var dexcomToken: String = ""
}
