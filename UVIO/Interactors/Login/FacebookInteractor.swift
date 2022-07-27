//
//  LoginFacebookInteractor.swift
//  UVIO
//
//  Created by Macostik on 24.05.2022.
//

import Combine
import FacebookLogin

protocol FacebookInteractor {
    func getData() -> AnyPublisher<SocialValueType?, Error>
}
