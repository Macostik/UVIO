//
//  APIInteractor.swift
//  UVIO
//
//  Created by Macostik on 12.07.2022.
//

import Foundation
import Alamofire

// swiftlint:disable function_parameter_count
protocol APIInteractor {
    func register(firstName: String,
                  lastName: String,
                  email: String,
                  password: String,
                  birthDate: String,
                  gender: String) -> DataResponsePublisher<RegisterResponsable>
    func login(email: String,
               password: String) -> DataResponsePublisher<RegisterResponsable>
}
