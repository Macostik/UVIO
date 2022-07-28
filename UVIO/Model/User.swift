//
//  User.swift
//  UVIO
//
//  Created by Macostik on 19.05.2022.
//

import Foundation
import RealmSwift

// swiftlint:disable identifier_name
struct UserResponsable: Decodable {
    let success: Bool
    let data: DataResponsable
}
struct DataResponsable: Decodable {
    let token: String
    let user: UserParam
}
struct UserParam: Decodable {
    let id: Int
    let name: String
    let email: String
    let birth_date: String
    let gender: String
    let updated_at: String
    let created_at: String
}

class User: Object {
    @Persisted(primaryKey: true) var id: Int
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
    @Persisted var isVibrate: Bool = false
    @Persisted var isNotDisturb: Bool = false
}
