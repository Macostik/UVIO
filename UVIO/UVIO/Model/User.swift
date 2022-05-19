//
//  User.swift
//  UVIO
//
//  Created by Macostik on 19.05.2022.
//

import Foundation

class User: ObservableObject {
    var name: String = ""
    var birthDate: String = ""
    var gender: String = ""
    var diabetsType: String = ""
    var email: String = ""
    var password: String = ""
    var glucoseUnit: String = ""
    var glucoseTargetLowBounce: String = ""
    var glucoseTargetUpperBounce: String = ""
    var hyper: String = ""
    var hypo: String = ""
}
