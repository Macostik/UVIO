//
//  APIProvider.swift
//  UVIO
//
//  Created by Macostik on 12.07.2022.
//

import Foundation
import Alamofire

private let timeOutInterval = 30.0

protocol APIProvider {
    var apiService: APIInteractor { get }
}

private enum APIRequest: URLRequestConvertible {
    case register([String: Any])
    case login([String: Any])
    func asURLRequest() throws -> URLRequest {
        let headers: [String: String]? = nil
        var method: HTTPMethod {
            switch self {
            case .register, .login:
                return .post
            }
        }
        let parameters: ([String: Any]?) = {
            switch self {
            case .login(let parameters),
                    .register(let parameters):
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
        case .login, .register:
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

// swiftlint:disable function_parameter_count
class APIService: APIInteractor {
    func register(firstName: String,
                  lastName: String,
                  email: String,
                  password: String,
                  birthDate: String,
                  gender: String) -> DataResponsePublisher<RegisterResponsable> {
        let params = [
            "first_name": firstName,
            "last_name": lastName,
            "email": email,
            "password": password,
            "birth_date": birthDate,
            "gender": gender
        ]
        return APIRequest.register(params).json(RegisterResponsable.self)
    }
    func login(email: String, password: String) -> DataResponsePublisher<RegisterResponsable> {
        let params = ["email": email, "password": password]
        return APIRequest.login(params).json(RegisterResponsable.self)
    }
}
