//
//  ViewModel.swift
//  UVIO
//
//  Created by Macostik on 20.07.2022.
//

import Combine
import SwiftUI
import RealmSwift
import Alamofire

class BaseViewModel: ObservableObject {}

struct ViewModel {
    var user: User? {
        userViewModel.user
    }
    var userViewModel: UserViewModel = {
        UserViewModel()
    }()
    var mainViewModel: MainViewModel = {
        MainViewModel()
    }()
    var connectCGMViewModel: ConnectCGMViewModel = {
        ConnectCGMViewModel()
    }()
}
