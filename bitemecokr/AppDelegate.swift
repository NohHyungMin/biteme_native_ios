//
//  AppDelegate.swift
//  bitemecokr
//
//  Created by 위트플러스 on 2023/03/01.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications
import AirBridge
//import BuzzBooster
import AppTrackingTransparency

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //BuzzBooster 초기화
        //let config = BSTConfig { builder in
            //개발 키
          //builder.appKey = "551289185238729"
            //운영 키
        //  builder.appKey = "438941575517733"
        //}
        //BuzzBooster.initialize(with: config)
        //BuzzBooster.startService()
        
        //에어브릿지 초기화
        // Override point for customization after application launch.
        AirBridge.setSessionTimeout(1000 * 60 * 5)
        AirBridge.setting()?.trackingAuthorizeTimeout = 30 * 1000
        AirBridge.setting()?.isRestartTrackingAuthorizeTimeout = false
        AirBridge.getInstance("09d40c24d8f54fd0a7866a99d577d7b7", appName:"biteme", withLaunchOptions:launchOptions)
        
        //에어브릿지 딥링크 처리
        AirBridge.deeplink()?.setDeeplinkCallback({ deeplink in
                // 딥링크로 앱이 열리는 경우 작동할 코드
                // Airbridge 를 통한 Deeplink = YOUR_SCHEME://...
            // DEEPLINK 저장 해서 ViewController에서 사용 (앱이 완전 종료되고 사용 할때 쓰임)
            let userDefault = UserDefaults.standard
            userDefault.set(deeplink, forKey: "DEEPLINK")
            userDefault.synchronize()
            
            if let viewController = UIApplication.shared.keyWindow?.rootViewController?.topMostViewController as? ViewController {
                // handlePushNotification 메서드 호출
                viewController.handlePushNotification(urlString: deeplink)
            }
        })
        // 알림 초기화
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let introViewController = storyboard.instantiateViewController(withIdentifier: "IntroViewController") as! IntroViewController
        let navigationController = UINavigationController(rootViewController: introViewController)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
                
        // 앱버전 체크 후 업데이트  Start
//        _ = try?  self.isUpdateAvailable { (update, error) in
//        if let error = error {
//            print(error)
//        } else if let update = update {
//
//    //              print("update : \(update)")
//              if update {
//                 //self.appUpdate()
//                 return
//              }
//           }
//        }
        // 앱버전 체크 후 업데이트  End
        
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        // 10버전 이상
        if #available(iOS 10.0, *) {
        
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self
        
//          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//          UNUserNotificationCenter.current().requestAuthorization(
//            options: authOptions,
//            completionHandler: {_, _ in })
            let options: UNAuthorizationOptions = [.alert, .sound, .badge]
            UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, error) in
                if error != nil {
                    print(error!)
                } else {
                    if granted {
                        print("Notification permission granted")
                    } else {
                        print("Notification permission denied")
                    }
                }
                self.setNotification()
            }
            
            application.registerForRemoteNotifications()
            
        } else {
        
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        // 메시징 델리겟
        Messaging.messaging().delegate = self
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            }
            else if let token = token {
                print("FCM registration token: \(token)")
            }
        }
        
        print("application didFinishLaunchingWithOptions")
        printState()
        return true
    }
    
    
    // fcm 토큰이 등록이 되었을 때
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        // Convert token to string (디바이스 토큰 값을 가져옵니다.)
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        // Print it to console(토큰 값을 콘솔창에 보여줍니다. 이 토큰값으로 푸시를 전송할 대상을 정합니다.)
        print("APNs device token: \(deviceTokenString)")
        
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool
    {
        AirBridge.deeplink()?.handleURLSchemeDeeplink(url)
        
        return true
    }
    
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool
    {
        AirBridge.deeplink()?.handle(userActivity)
        
        return true
    }
    
    
    enum VersionError: Error {
        case invalidResponse, invalidBundleInfo
    }
    
    // 업데이트 함수
//    func isUpdateAvailable(completion: @escaping (Bool?, Error?) -> Void) throws -> URLSessionDataTask {
//        guard let info = Bundle.main.infoDictionary,
//            let currentVersion = info["CFBundleShortVersionString"] as? String, // 현재 버전
//            let identifier = info["CFBundleIdentifier"] as? String,
//            let url = URL(string: "http://itunes.apple.com/kr/lookup?bundleId=\(identifier)") else {
//                throw VersionError.invalidBundleInfo
//        }
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            do {
//                if let error = error { throw error }
//                guard let data = data else { throw VersionError.invalidResponse }
//                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
//                guard let result = (json?["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String else {
//                    throw VersionError.invalidResponse
//                }
//
//
//                let verInt = NSString.init(string: version.components(separatedBy: ["."]).joined()).intValue
//                let currentVerInt = NSString.init(string: currentVersion.components(separatedBy: ["."]).joined()).intValue
//
//                print("verFloat : \(verInt) : currentVerFloat : \(currentVerInt)")
//                completion(verInt > currentVerInt, nil) // 현재 버전이 앱스토어 버전보다 큰지를 Bool값으로 반환
//            } catch {
//                completion(nil, error)
//            }
//        }
//        task.resume()
//        return task
//    }

//    func appUpdate() {
//       // id뒤에 값은 앱정보에 Apple ID에 써있는 숫자
//       if let url = URL(string: "itms-apps://itunes.apple.com/app/id1439162792"), UIApplication.shared.canOpenURL(url) {
//
//          // 앱스토어로 이동\
//          if #available(iOS 10.0, *) {
//             UIApplication.shared.open(url, options: [:], completionHandler: nil)
//          } else {
//              UIApplication.shared.openURL(url)
//          }
//       }
//    }
    
    func application(
            _ application: UIApplication,
            didReceiveRemoteNotification userInfo: [AnyHashable : Any],
            fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
        ) {
            print("didReceiveRemoteNotification")
            //푸쉬 받을 때 실행
            let badgeCount = UserDefaults.standard.integer(forKey: "BADGECOUNT")
            UIApplication.shared.applicationIconBadgeNumber = badgeCount + 1
            let userDefault = UserDefaults.standard
            userDefault.set(badgeCount + 1, forKey: "BADGECOUNT")
            userDefault.synchronize()
            
            completionHandler(.newData)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        print("applicationWillEnterForeground")
        printState()
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        print("applicationDidBecomeActive")
        printState()
    }
    func applicationWillResignActive(_ application: UIApplication) {
        print("applicationWillResignActive")
        printState()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")
        printState()
    }
    func sceneWillEnterForeground(_ scene: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        print("sceneWillEnterForeground")
        printState()
    }
    
    
    private func printState() {
        switch UIApplication.shared.applicationState {
            case .active:
                print("state: active")
            case .background:
                print("state: background")
            case .inactive:
                print("state: inactive")
        default:
                print("default")
        }
    }
    
    func setNotification(){
        // 다른 권한 요청 창보다 늦게 띄우기
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                    switch status {
                    case .authorized:        // 허용됨
                        print("Authorized")   // IDFA 접근
                    case .denied:        // 거부됨
                        print("Denied")
                    case .notDetermined:    // 결정되지 않음
                        print("Not Determined")
                    case .restricted:        // 제한됨
                        print("Restricted")
                    @unknown default:        // 알려지지 않음
                        print("Unknown")
                    }
                })
            }
        }
    }
}



extension AppDelegate: UNUserNotificationCenterDelegate {
    // 실행중 앱 푸시 올 경우
  func userNotificationCenter(_ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert, .badge, .sound])
    print("push")
  }
  // 푸시 클릭 시 실행
  func userNotificationCenter(_ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
      
      UIApplication.shared.applicationIconBadgeNumber = 0
      let userInfo = response.notification.request.content.userInfo
      let userDefault = UserDefaults.standard
      // push seq값 저장
      if let seq = userInfo["seq"] as? String {
          userDefault.set(seq, forKey: "PUSH_SEQ")
          userDefault.synchronize()
      }
      // 링크 값이 있을 경우
      if let link = userInfo["link"] as? String {
          print("url : ",link)
          
          // PUSH_URL 저장 해서 ViewController에서 사용 (앱이 완전 종료되고 사용 할때 쓰임)
           userDefault.set(link, forKey: "PUSH_URL")
           userDefault.synchronize()
          
          if let viewController = UIApplication.shared.keyWindow?.rootViewController?.topMostViewController as? ViewController {
              // handlePushNotification 메서드 호출
              viewController.handlePushNotification(urlString: link)
          }
      }
      completionHandler()
  }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict:[String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}

// 최상위 cntroller를 확인해줌 
extension UIViewController {
    var topMostViewController: UIViewController {
        if let presented = presentedViewController {
            return presented.topMostViewController
        }
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController ?? navigation
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController ?? tab
        }
        return self
    }
}
