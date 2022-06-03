//
//  DependencyProvider.swift
//  UVIO
//
//  Created by Macostik on 25.05.2022.
//

import Foundation
import Resolver

protocol DependencyProvider {
    var provider: Provider { get set }
}

struct Dependency: DependencyProvider {
     var provider = Provider()
}
