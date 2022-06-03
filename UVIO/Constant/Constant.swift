//
//  Constant.swift
//  UVIO
//
//  Created by Macostik on 26.05.2022.
//

import Foundation

struct Constant {
    static let groupID = "group.com.GYS.UVIO"
    static let clientID = "858527894249-6oh5e3gmudg6aoqvu3njti03cj38mdc0.apps.googleusercontent.com"
    static let oAuthID = "cone"
    static let dexcomSecretClientID = "9qaNhXG3p1TzxpuW0ywa8Do3BkzPlAif"
    static let dexcomSecretKey = "hu7RAwDqqF7UDIQt"
    static let returnURL: String = "cone://com.GYS.UVIO"
    static let authURL: String = "https://api.dexcom.com/v2/oauth2/login"
    static let authToken: String = "https://api.dexcom.com/v2/oauth2/token"
    static let authType: String = "code"
    static let authScope: String = "offline_access"
}
