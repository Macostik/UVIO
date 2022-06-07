//
//  LoginFacebookInteractor.swift
//  UVIO
//
//  Created by Macostik on 24.05.2022.
//

import Resolver
import Combine
import FacebookLogin

protocol FacebookInteractor {
    func getBearer() -> AnyPublisher<Token?, Error>
}
