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
    func profile(userID: String,
                 diabetesType: String,
                 glucoseUnit: String,
                 glucoseTargetMin: String,
                 glucoseTargetMax: String,
                 glucoseHyper: String,
                 glucoseHypo: String,
                 glucoseSensor: String,
                 country: String,
                 alertVibrate: String,
                 dontDisturb: String) -> DataResponsePublisher<DiabetesValueResponsable>
    func devices(userID: String,
                 apiToken: String,
                 refreshApiToken: String) -> DataResponsePublisher<DiabetesValueResponsable>
}
