//
//  LoginGoogleInteractor.swift
//  UVIO
//
//  Created by Macostik on 25.05.2022.
//

import Foundation
import Combine

protocol LoginGoogleInteractor {
    func login() -> AnyPublisher<UserData, Error>
}
