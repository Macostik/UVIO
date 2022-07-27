//
//  FacebookProvider.swift
//  UVIO
//
//  Created by Macostik on 23.05.2022.
//

import Foundation
import FBSDKLoginKit
import Combine
import UIKit

protocol FacebookProvider {
    var facebookService: FacebookInteractor { get }
}

struct FacebookService: FacebookInteractor {
    let loginManager = LoginManager()
    func getData() -> AnyPublisher<SocialValueType?, Error> {
        loginManager.authorizePublisher()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}
