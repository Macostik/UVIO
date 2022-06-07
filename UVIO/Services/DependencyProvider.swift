//
//  DependencyProvider.swift
//  UVIO
//
//  Created by Macostik on 25.05.2022.
//

import Foundation
import Combine
import SwiftUI

protocol DependencyProvider {
    var provider: Provider { get set }
}

private struct DependencyKey: EnvironmentKey {
  static let defaultValue = Dependency()
}

extension EnvironmentValues {
  var dependency: Dependency {
    get { self[DependencyKey.self] }
    set { self[DependencyKey.self] = newValue }
  }
}

struct Dependency: DependencyProvider {
     var provider = Provider()
}
