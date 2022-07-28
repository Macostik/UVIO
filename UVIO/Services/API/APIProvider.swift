//
//  APIProvider.swift
//  UVIO
//
//  Created by Macostik on 12.07.2022.
//

import Foundation
import Alamofire

private let timeOutInterval = 30.0
// swiftlint:disable function_body_length function_parameter_count superfluous_disable_command
protocol APIProvider {
    var apiService: APIInteractor { get }
}

private enum APIRequest: URLRequestConvertible {
    case register([String: Any])
    case login([String: Any])
    case socialLogin([String: Any])
    case profile([String: Any])
    func asURLRequest() throws -> URLRequest {
        let headers: [String: String]? = nil
        var method: HTTPMethod {
            switch self {
            case .register, .login, .socialLogin, .profile:
                return .post
            }
        }
        let parameters: ([String: Any]?) = {
            switch self {
            case .login(let parameters),
                    .register(let parameters),
                    .socialLogin(let parameters),
                    .profile(let parameters):
                return parameters
            }
        }()
        let url: URL = {
            var URL = Foundation.URL(string: Constant.baseURL)!
            let query: String?
            switch self {
            case .login:
                query = "login"
            case .register:
                query = "register"
            case .socialLogin:
                query = "login-social"
            case .profile:
                query = "profiles"
            }
            if let query = query {
                URL = URL.appendingPathComponent(query)
            }
            return URL
        }()
        Logger.warrning("REQUEST for \n\t url - \(url)\n\t method - \(method)\n\t parameters - " +
                        "\(parameters ?? [:])")
#if DEBUG
        Logger.warrning("header - \(headers ?? [:])")
#endif
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = timeOutInterval
        if let headers = headers {
            for (headerField, headerValue) in headers {
                urlRequest.setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
        switch self {
        case .login, .register, .socialLogin, .profile:
            return try URLEncoding(arrayEncoding: .noBrackets).encode(urlRequest, with: parameters)
//        default:
//            return try URLEncoding.default.encode(urlRequest, with: parameters)
        }
    }
    public func json<T: Decodable>(_ object: T.Type,
                                   file: Any = #file,
                                   function: Any = #function,
                                   line: Int = #line) -> DataResponsePublisher<T> {
        let publisher = AF.request(self).publishDecodable(type: T.self)
        Logger.verbose("RESPONSE by request - \(self)" +
                       " \n\t [\((file as? NSString)?.lastPathComponent ?? ""): \(line)] \(function): " +
                       "RESPONSE - \(publisher)")
        return publisher
    }
    public func data(_ file: Any = #file,
                     function: Any = #function,
                     line: Int = #line) -> DataResponsePublisher<Data?> {
        let publisher = AF.request(self).publishUnserialized()
        Logger.verbose("RESPONSE by request - \(self)" +
                       " \n\t [\((file as? NSString)?.lastPathComponent ?? ""): \(line)] \(function): " +
                       "RESPONSE - \(publisher)")
        return publisher
    }
}

class APIService: APIInteractor {
    func register(name: String,
                  email: String,
                  password: String,
                  birthDate: String,
                  gender: String) -> DataResponsePublisher<UserResponsable> {
        let params = [
            "name": name,
            "email": email,
            "password": password,
            "birth_date": birthDate,
            "gender": gender
        ]
        return APIRequest.register(params).json(UserResponsable.self)
    }
    func login(email: String,
               password: String) -> DataResponsePublisher<UserResponsable> {
        let params = ["email": email, "password": password]
        return APIRequest.login(params).json(UserResponsable.self)
    }
    func socialLogin(name: String,
                     email: String,
                     token: String,
                     platform: String) -> DataResponsePublisher<UserResponsable> {
        let params = ["name": name, "email": email, "token": token, "platform": platform]
        return APIRequest.socialLogin(params).json(UserResponsable.self)
    }
    func profile(userID: String = "",
                 diabetesType: String = "",
                 glucoseUnit: String = "",
                 glucoseTargetMin: String = "",
                 glucoseTargetMax: String = "",
                 glucoseHyper: String = "",
                 glucoseHypo: String = "",
                 glucoseSensor: String = "",
                 country: String = "",
                 alertVibrate: String = "",
                 dontDisturb: String = "") -> DataResponsePublisher<UserResponsable> {
        let params = [
            "user_id": userID,
            "diabetes_type": diabetesType,
            "glucose_unit": glucoseUnit,
            "glucose_target_min": glucoseTargetMin,
            "glucose_target_max": glucoseTargetMax,
            "glucose_hyper": glucoseHyper,
            "glucose_hypo": glucoseHypo,
            "glucose_sensor": glucoseSensor,
            "country": country,
            "alerts_vibrate": alertVibrate,
            "override_do_not_disturb": dontDisturb
        ]
        return APIRequest.register(params).json(UserResponsable.self)
    }
}
