//
//  NotificationService.swift
//  NotificationService
//
//  Created by Hyung-Min Noh on 2023/01/10.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title)"
            
            // * 이미지를 가져와서 push에 추가하는 부분
           // - userInfo["image"]에서 이미지 URL 정보를 가져옵니다. (전송된 푸시 내용은 "5." 에서 확인하세요)
            
            //if let bestAttemptContent = bestAttemptContent{
                let imageData = request.content.userInfo["fcm_options"] as? [String:Any]
                let attachmentString = imageData?["image"] as? String
                if(attachmentString != nil){
                   if let imagePath = self.image(attachmentString!) {
                       let imageURL = URL(fileURLWithPath: imagePath)
                       do {
                           let attach = try UNNotificationAttachment(identifier: "imagenoti", url: imageURL, options: nil)
                           bestAttemptContent.attachments = [attach]
                       } catch {
                           print(error)
                       }
                   }
                }
          // }
            
            
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    // * 이미지를 가져오는 함수 추가 구성
    func image(_ URLString: String) -> String? {
        let componet = URLString.components(separatedBy: "/")

        if let fileName = componet.last {
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)

            if let documentsPath = paths.first {
                let filePath = documentsPath.appending("/" + fileName)
                if let imageURL = URL(string: URLString) {
                    do {
                        let data = try NSData(contentsOf: imageURL, options: NSData.ReadingOptions(rawValue: 0))
                        if data.write(toFile: filePath, atomically: true) {

                            return filePath
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
        return nil
    }

}
