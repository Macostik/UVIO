//
//  AuthToken.swift
//  UVIO
//
//  Created by Macostik on 18.07.2022.
//

import Foundation
import RealmSwift

class AuthToken: Object {
    @Persisted var token: String = ""
}

class DexcomToken: Object {
    @Persisted var token: String = ""
}
