//
//  AppleInteractor.swift
//  UVIO
//
//  Created by Macostik on 06.06.2022.
//

import Foundation
import Combine

protocol AppleInteractor {
    func signIn() -> AnyPublisher<UserData, Error>
}
