//
//  SceneDelegate.swift
//  UVIO
//
//  Created by Macostik on 16.05.2022.
//

import UIKit
import SwiftUI
import Combine
import Foundation
import OAuthSwift

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            UIScrollView.appearance().bounces = false
            let viewModel = UserViewModel()
            let weeklyView = SplashView(viewModel: viewModel)
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: weeklyView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        OAuthSwift.handle(url: url)
    }
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
}
