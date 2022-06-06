//
//  LoginGoogleInteractor.swift
//  UVIO
//
//  Created by Macostik on 25.05.2022.
//

import Foundation
import Combine

protocol GoogleInteractor {
    func singIn() -> AnyPublisher<UserData, Error>
}