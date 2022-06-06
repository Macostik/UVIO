//
//  AppDelegate.swift
//  UVIO
//
//  Created by Macostik on 16.05.2022.
//

import UIKit
import Combine
import FBSDKCoreKit
import FirebaseCore
import FirebaseMessaging

typealias NotificationPayload = [AnyHashable: Any]
typealias FetchCompletion = (UIBackgroundFetchResult) -> Void

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in
            }
        )
        application.registerForRemoteNotifications()
        return ApplicationDelegate.shared.application(application,
                                                      didFinishLaunchingWithOptions: launchOptions)
    }
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        Logger.debug("Success in registering for remote notifications with token \(deviceTokenString)")
    }
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Logger.error("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[Constant.gcmMessageID] {
            Logger.debug("Message ID: \(messageID)")
        }
    }
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: NotificationPayload,
                     fetchCompletionHandler completionHandler: @escaping FetchCompletion) {
        if let messageID = userInfo[Constant.gcmMessageID] {
            Logger.debug("Background message ID: \(messageID)")
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    private func sceneDelegate(_ application: UIApplication) -> SceneDelegate? {
        return application.windows
            .compactMap({ $0.windowScene?.delegate as? SceneDelegate })
            .first
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
        let userInfo = notification.request.content.userInfo
        if let messageID = userInfo[Constant.gcmMessageID] {
            Logger.debug("Message ID: \(messageID)")
        }
        completionHandler([[.sound]])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let messageID = userInfo[Constant.gcmMessageID] {
            Logger.debug("Message ID: \(messageID)")
        }
        completionHandler()
    }
}
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Logger.debug("Firebase registration token: \(fcmToken ?? "")")
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name(Constant.fcmTokenKey),
            object: nil,
            userInfo: dataDict
        )
    }
}
