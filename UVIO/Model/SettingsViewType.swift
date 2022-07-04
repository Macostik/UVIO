//
//  SettingsViewType.swift
//  UVIO
//
//  Created by Macostik on 04.07.2022.
//

import Foundation
import SwiftUI

enum SettingsViewType {
    case none, summary, accountInformation, bgLevelAlert, devices
    var title: String {
        switch self {
        case .none: return L10n.empty
        case .summary: return  L10n.mySummary
        case .accountInformation: return L10n.accountInformation
        case .bgLevelAlert: return L10n.bgLevels
        case .devices: return L10n.devices
        }
    }
}
