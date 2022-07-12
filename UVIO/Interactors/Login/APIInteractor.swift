//
//  APIInteractor.swift
//  UVIO
//
//  Created by Macostik on 12.07.2022.
//

import Foundation
import Alamofire

protocol APIInteractor {
    func allDevices<T: Decodable>() -> DataResponsePublisher<T>
}
