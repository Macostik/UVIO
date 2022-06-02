//
//  DexcomInteractor.swift
//  UVIO
//
//  Created by Macostik on 02.06.2022.
//

import Foundation
import Combine

typealias Token = String
protocol DexcomInteractor {
    func getBearer() -> AnyPublisher<String, Error>
}
