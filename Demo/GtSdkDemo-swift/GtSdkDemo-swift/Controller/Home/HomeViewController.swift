//
//  HomeViewController.swift
//  GtSdkDemo-swift
//
//  Created by ak on 2020/03/20.
//  Copyright © 2020 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//

import UIKit
import GTSDK

class HomeViewController: UIViewController {
  
  @IBOutlet weak var contentTextView: UITextView!
  @IBOutlet weak var contentBGView: UIView!
  @IBOutlet weak var pushLocationBtn: UIButton!
  @IBOutlet weak var pushSwitch: UISwitch!
  @IBOutlet weak var sdkServiceSwitch: UISwitch!
  @IBOutlet weak var cidLabel: UILabel!
  @IBOutlet weak var deviceTokenLabel: UILabel!
  @IBOutlet weak var sdkStateLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    contentBGView.layer.cornerRadius = 6
    pushLocationBtn.layer.cornerRadius = 8
    updatePushMode(UserDefaults.pushMode)
    updateStatusView()
    NotificationCenter.default.addObserver(self, selector: #selector(updateStatusView), name: .GTSDKState, object: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc func updateStatusView() {
    let status = GeTuiSdk.status()
    sdkStateLabel.text = status.title
    switch status {
    case .started:
      cidLabel.text = GeTuiSdk.clientId()
      sdkServiceSwitch.isOn = true
    case .starting:
      cidLabel.text = ""
      sdkServiceSwitch.isOn = false
    case .offline:
      sdkServiceSwitch.isOn = true
    default:
      cidLabel.text = ""
      sdkServiceSwitch.isOn = false
    }
  }
  
  func updatePushMode(_ flag: Bool) {
    pushSwitch.isOn = flag
    UserDefaults.setPushMode(flag)
  }
  
  func updateDeviceToken(_ token: String) {
    deviceTokenLabel.text = token
  }
  
  
  // MARK: Click Action
  
  @IBAction func pushLocation(_ sender: Any) {
    pushLocalNotification(title: "测试本地推送使用")
  }
  
  @IBAction func clearContentClick(_ sender: Any) {
    contentTextView.text = ""
    contentTextView.scrollRangeToVisible(NSMakeRange(contentTextView.text.count , 0))
  }
  
  @IBAction func sdkServiceSwitch(_ sender: Any) {
    let status = GeTuiSdk.status()
    if sdkServiceSwitch.isOn, status == .stoped {
      GeTuiSdk.start(withAppId: kGtAppId, appKey: kGtAppKey, appSecret: kGtAppSecret, delegate:  UIApplication.shared.delegate as! GeTuiSdkDelegate)
    } else {
        if (status == .started || status == .starting) {
        // [ GTSDK ] 销毁SDK
        GeTuiSdk.destroy()
      }
    }
  }
  
  @IBAction func pushModeSwitch(_ sender: Any) {
    if (GeTuiSdk.status() != .stoped) {
      UserDefaults.setPushMode(pushSwitch.isOn)
      GeTuiSdk.setPushModeForOff(pushSwitch.isOn)
    } else {
      logMsg("GeTuiSDK未启动")
    }
  }
  
  func logMsg(_ msg: String) {
    NSLog("%@", msg)
    guard let contentTextView = contentTextView else { return }
    contentTextView.text = "\(contentTextView.text ?? "")\n\(msg)"
    contentTextView.scrollRangeToVisible(NSMakeRange(contentTextView.text.count , 0))
  }
  
  func pushLocalNotification(title: String) {
    // 创建本地通知时，清理之前所有的本地通知，注意：根据App具体的功能自行修改
    // 清理所有本地通知，程序启动时清理，注意：根据App具体功能需求自行修改，如果App内有其他本地通知，更加需要注意是否要清理所有通知
    UIApplication.shared.cancelAllLocalNotifications()
    let localNotify = UILocalNotification()
    let pushDate = Date(timeIntervalSinceNow: 1)
    
    localNotify.fireDate = pushDate as Date
    localNotify.timeZone = NSTimeZone.default
    localNotify.repeatInterval = NSCalendar.Unit.day
    localNotify.soundName = UILocalNotificationDefaultSoundName
    let dateTime = formateTime(date:NSDate(timeIntervalSinceNow: 1))
    
    localNotify.alertBody = "Payload : \(title),time : \(dateTime)"
    localNotify.alertAction = NSLocalizedString("View Details", comment: "")
    let notifyArray = UIApplication.shared.scheduledLocalNotifications
    localNotify.applicationIconBadgeNumber = notifyArray!.count + 1
    UIApplication.shared.scheduleLocalNotification(localNotify)
  }
  
  func formateTime(date:NSDate) -> NSString {
    let formatter = DateFormatter.init()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let dateTime = formatter.string(from: date as Date)
    return dateTime as NSString
  }
}


extension UserDefaults {
  static var pushMode: Bool {
    return UserDefaults.standard.bool(forKey: "OffPushMode")
  }
  static func setPushMode(_ mode: Bool) {
    UserDefaults.standard.set(mode, forKey: "OffPushMode")
  }
}
