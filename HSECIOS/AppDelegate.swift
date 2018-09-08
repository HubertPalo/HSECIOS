//
//  AppDelegate.swift
//  HSECIOS
//
//  Created by Mac02 on 15/12/17.
//  Copyright © 2017 pangolabs. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
        
        // Override point for customization after application launch.
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        if let dicTemp = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] {
            print(dicTemp)
        } else {
            print("asdasdasdadasdasdasdasdasdsadasdsaasdsada--------")
        }
        
        Config.initConfig()
        Config.getAllMaestro(false, false)
        Tabs.initTabs()
        Globals.loadGlobals()
        VCHelper.initVCs()
        Images.initImages()
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .normal)
        UINavigationBar.appearance().tintColor = UIColor.lightGray
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: Colores.blancoTabBarNoSelected], for: UIControlState.normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: Colores.blancoTabBarSelected], for: .selected)
        
        
        return true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        Utils.FCMToken = fcmToken
        Rest.postDataGeneral(Routes.forLogin(), ["username":Utils.loginUsr, "password":Utils.loginPwd, "domain":"anyaccess", "token":Utils.FCMToken], false, success: {(resultValue:Any?,data:Data?) in
            if let respuesta = resultValue as? String {
                Utils.token = respuesta
                print(respuesta)
                // Utils.actualView.presentAlert(respuesta, Utils.FCMToken, .alert, 2, nil, [], [], actionHandlers: [])
            }
        }, error: {(error) in
            print(error)
            // Utils.actualView.presentAlert("Error", error, .alert, 2, nil, [], [], actionHandlers: [])
        })
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Recibio notificacion")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(String.init(data: deviceToken, encoding: .utf8))
        // Messaging.messaging().subscribe(toTopic: "/topics/notificaciones")
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("remoteMessage: \(remoteMessage)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("userNotificationCenter didReceive response")
        print("User Info = \(response.notification.request.content.userInfo)")
        /*let codigo = response.notification.request.content.userInfo["codigo"] as? String
        let titulo = response.notification.request.content.userInfo["titulo"] as? String
        let fecha = response.notification.request.content.userInfo["fecha"] as? String
        
        if codigo == nil {
            UtilsNotificaciones.codigo = ""
        } else {
            UtilsNotificaciones.codigo = codigo!
        }
        if fecha == nil {
            UtilsNotificaciones.fecha = ""
        } else {
            UtilsNotificaciones.fecha = fecha!
        }
        if fecha == nil {
            UtilsNotificaciones.titulo = ""
        } else {
            UtilsNotificaciones.titulo = titulo!
        }*/
        completionHandler()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return Utils.orientation
    }

}

