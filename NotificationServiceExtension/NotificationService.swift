//
//  NotificationService.swift
//  NotificationServiceExtension
//
//  Created by 위트플러스 on 2023/03/01.
//

import UserNotifications
import MobileCoreServices


class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
//        print("test2")
        
        if let bestAttemptContent = bestAttemptContent {
//            print("test1")
            let imageData = request.content.userInfo["fcm_options"] as? [String : Any]
            guard let attachmentString = imageData?["image"] as? String else {
                contentHandler(bestAttemptContent)
                return
            }
            if let attachmentUrl = URL(string: attachmentString) {
                let session = URLSession(configuration: URLSessionConfiguration.default)
                let downloadTask = session.downloadTask(with: attachmentUrl, completionHandler: { (url, _, error) in
                    if let error = error {
                        print("Error downloading attachment: \(error.localizedDescription)")
                    } else if let url = url {
                        let attachment = try! UNNotificationAttachment(identifier: attachmentString, url: url, options: [UNNotificationAttachmentOptionsTypeHintKey : kUTTypePNG])
                        bestAttemptContent.attachments = [attachment]
                    }
                    contentHandler(bestAttemptContent)
                })
                downloadTask.resume()
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
