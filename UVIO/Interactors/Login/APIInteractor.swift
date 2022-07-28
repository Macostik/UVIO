//
//  APIInteractor.swift
//  UVIO
//
//  Created by Macostik on 12.07.2022.
//

import Foundation
import Alamofire

protocol APIInteractor {
    func register(name: String,
                  email: String,
                  password: String,
                  birthDate: String,
                  gender: String) -> DataResponsePublisher<UserResponsable>
    func login(email: String,
               password: String) -> DataResponsePublisher<UserResponsable>
    func socialLogin(name: String,
                     email: String,
                     token: String,
                     platform: String) -> DataResponsePublisher<UserResponsable>
}
