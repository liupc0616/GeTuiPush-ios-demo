//
//  NotificationService.swift
//  NotificationService
//
//  Created by ak on 16/10/10.
//  Copyright © 2020 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//

import UserNotifications
import GTExtensionSDK
class NotificationService: UNNotificationServiceExtension {
  
  var contentHandler: ((UNNotificationContent) -> Void)?
  var bestAttemptContent: UNMutableNotificationContent?
  
  override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
    self.contentHandler = contentHandler
    guard let bestAttemptContent = request.content.mutableCopy() as? UNMutableNotificationContent else { return }
   
    // [ 测试代码 ] TODO：语音播报
    let cnt: Double = 123 //读取apns中播报信息
    let name = ApnsHelper.makeMp3FromExt(cnt)
    let sound = UNNotificationSound(named: UNNotificationSoundName(name))
    bestAttemptContent.sound = sound
    
    // [ 测试代码 ] TODO: 用户可以在这里处理通知样式的修改，eg:修改标题，开发阶段可以用于判断是否运行通知扩展
//    bestAttemptContent.title = "\(bestAttemptContent.title) [WillIn]"
    
    // [ GTSDK ] 统计APNs到达情况和多媒体推送支持接口, 建议使用该接口
    GeTuiExtSdk.handelNotificationServiceRequest(request, withAttachmentsComplete: { [weak self] (attachments: Array?, errors: Array?) in
      guard let handler = self?.contentHandler else { return }
      // [ 测试代码 ] TODO：日志打印，如果APNs处理有错误，可以在这里查看相关错误详情
      // print("处理个推APNs展示遇到错误：\(String(describing: errors))")
      
      // [ 测试代码 ] TODO：用户可以在这里处理通知样式的修改，eg:修改标题，开发阶段可以用于判断是否运行通知扩展
      bestAttemptContent.title = "\(bestAttemptContent.title) [Success]"
      if let attachment = attachments as? [UNNotificationAttachment], !attachment.isEmpty {
        // 设置通知中的多媒体附件
        bestAttemptContent.attachments = attachment
      }
      // 展示推送的回调处理需要放到个推回执完成的回调中
      handler(bestAttemptContent)
    })
  }
  
  override func serviceExtensionTimeWillExpire() {
    // [ GTSDK ] 销毁SDK，释放资源
    GeTuiExtSdk.destory()
    
    // [ 测试代码 ] TODO：测试时查看超时情况，eg:修改标题，开发阶段可以用于判断是否运行通知扩展
    // bestAttemptContent?.title = "\(String(describing: bestAttemptContent?.title)) [Timeout]"
    
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
      contentHandler(bestAttemptContent)
    }
  }
  
}
