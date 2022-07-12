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
    case allDevices([String: Any])
    func asURLRequest() throws -> URLRequest {
        let headers: [String: String]? = nil
        var method: HTTPMethod {
            switch self {
            case .allDevices:
                return .get
            }
        }
        let parameters: ([String: Any]?) = {
            switch self {
            case .allDevices(let parameters):
                return parameters
            }
        }()
        let url: URL = {
            var URL = Foundation.URL(string: Constant.baseURL)!
            let query: String?
            switch self {
            case .allDevices:
                query = "devices"
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
        case .allDevices:
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
    func allDevices<T: Decodable>() -> DataResponsePublisher<T> {
        let params = ["name": "Dexcom", "version": "1.11", "model": "v1"]
        return APIRequest.allDevices(params).json(T.self)
    }
}
