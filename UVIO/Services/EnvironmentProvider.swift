//
//  EnvironmentProvider.swift
//  UVIO
//
//  Created by Macostik on 24.05.2022.
//

import Foundation

struct EnvironmentProvider {
    static let ENV = Bundle.main.object(forInfoDictionaryKey: "Environment") as? String ?? "DEV"
    static var DEV = "DEV"
    static var STG = "STG"
    static var PROD = "PROD"
    static let isProduction = ENV == PROD
    static let isDevelop = ENV == DEV
}
