//
//  GtSdkDemo.swift
//  GtSdkDemo-SwiftUI
//
//  Created by ak on 2021/8/6.
//
import SwiftUI
import PushKit
import os
import GTSDK

let kGtAppId = "xXmjbbab3b5F1m7wAYZoG2"
let kGtAppKey = "BZF4dANEYr8dwLhj6lRfx2"
let kGtAppSecret = "yXRS5zRxDt8WhMW8DD8W05"

@main
struct GtSdkDemo: App {
  @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
  
  var body: some Scene {
    WindowGroup {
      Home()
    }
  }
}

class AppDelegate: UIResponder, UIApplicationDelegate, GeTuiSdkDelegate, UNUserNotificationCenterDelegate, PKPushRegistryDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let msg = "[ TestDemo ] \(#function)"
    print(msg)
    // [ GTSDK ]：是否允许APP后台运行
    //        GeTuiSdk.runBackgroundEnable(true)
    
    // [ GTSDK ]：是否运行电子围栏Lbs功能和是否SDK主动请求用户定位
    //        GeTuiSdk.lbsLocationEnable(true, andUserVerify: true)
    
    // [ GTSDK ]：自定义渠道
    //        GeTuiSdk.setChannelId("GT-Channel")
    
    // [ GTSDK ]：使用APPID/APPKEY/APPSECRENT启动个推
    GeTuiSdk.start(withAppId: kGtAppId, appKey: kGtAppKey, appSecret: kGtAppSecret, delegate: self)
    
    // [ 参考代码，开发者注意根据实际需求自行修改 ] 注册远程通知
    GeTuiSdk.registerRemoteNotification([.alert, .badge, .sound])
    
    return true
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    var token = ""
    for byte in deviceToken {
      token += String(format: "%02X", byte)
    }
    // [ GTSDK ]：向个推服务器注册deviceToken
    // 2.5.2.0 之前版本需要调用：
    // homePage.updateDeviceToken(token)
    let msg = "[ TestDemo ] \(#function):\(token)"
    print(msg)
  }
    
  // MARK: - VOIP 接入
  
  /**
   * [ 参考代码，开发者注意根据实际需求自行修改 ] 注册VOIP服务
   *
   * 警告：以下为参考代码, 注意根据实际需要修改.
   *
   */
  func voipRegistration() {
    let voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
    voipRegistry.delegate = self
    if #available(iOS 9.0, *) {
      voipRegistry.desiredPushTypes = [.voIP]
    }
  }
  
  // MARK: - PKPushRegistryDelegate 协议方法
  
  /// [ 系统回调 ] 系统返回VOIPToken，并提交个推服务器
  func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
    // [ GTSDK ]：（新版）向个推服务器注册 VoipToken
    GeTuiSdk.registerVoipTokenCredentials(credentials.token)
    NSLog("[ TestDemo ] [ VoipToken(NSData) ]: %@\n\n", NSData(data: credentials.token))
  }
  
  /**
   * [ 系统回调 ] 收到voip推送信息
   * 接收VOIP推送中的payload进行业务逻辑处理（一般在这里调起本地通知实现连续响铃、接收视频呼叫请求等操作），并执行个推VOIP回执统计
   */
  func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
    //  [ GTSDK ]：个推VOIP回执统计
    GeTuiSdk.handleVoipNotification(payload.dictionaryPayload)
    
    // [ 测试代码 ] 接受VOIP推送中的payload内容进行具体业务逻辑处理
    NSLog("[ TestDemo ] [ Voip Payload ]: %@, %@", payload, payload.dictionaryPayload)
  }
  
  // MARK: - AppLink 接入
  
  /// [ 系统回调 ] APPLink回调
  func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    // [ GTSDK ]：处理个推APPLink回执统计
    // APPLink url 示例：https://link.gl.ink/getui?n=payload&p=mid， 其中 n=payload 字段存储用户透传信息，可以根据透传内容进行业务操作。
    //    GeTuiSdk.handleApplinkFeedback(userActivity.webpageURL)
    if let url = userActivity.webpageURL {
      let payload = GeTuiSdk.handleApplinkFeedback(url)
      NSLog("[ TestDemo ]  个推APPLink中携带的用户payload信息:\(url), payload:\(String(describing: payload)) \n\n")
      // TODO: 用户可根据具体 payload 进行业务处理
    }
    return true
  }
  
  // MARK: - GeTuiSdkDelegate
  
  
  /// [ GTSDK回调 ] SDK启动成功返回cid
  func geTuiSdkDidRegisterClient(_ clientId: String) {
    let msg = "[ TestDemo ] \(#function):\(clientId)"
    print(msg)
  }
  
  /// [ GTSDK回调 ] SDK运行状态通知
  func geTuiSDkDidNotifySdkState(_ aStatus: SdkStatus) {
    NotificationCenter.default.post(name: .GTSDKState, object: nil)
  }
  
  /// [ GTSDK回调 ] SDK错误反馈
  func geTuiSdkDidOccurError(_ error: Error) {
    let msg = "[ TestDemo ] \(#function) \(error.localizedDescription)"
    print(msg)
  }
  
  //MARK: - 通知回调
  
  /// [ 系统回调 ] iOS 10及以上  APNs通知将要显示时触发
  @available(iOS 10.0, *)
  func geTuiSdkNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let msg = "[ TestDemo ] \(#function)"
    print(msg)
    // [ 参考代码，开发者注意根据实际需求自行修改 ] 根据APP需要，判断是否要提示用户Badge、Sound、Alert等
      completionHandler([.badge, .sound, .banner])
  }
  
  @available(iOS 10.0, *)
  func geTuiSdkDidReceiveNotification(_ userInfo: [AnyHashable : Any], notificationCenter center: UNUserNotificationCenter?, response: UNNotificationResponse?, fetchCompletionHandler completionHandler: ((UIBackgroundFetchResult) -> Void)? = nil) {
    let msg = "[ TestDemo ] \(#function) \(userInfo)"
    print(msg)
    // [ 参考代码，开发者注意根据实际需求自行修改 ]
    completionHandler?(.noData)
  }
  
  func geTuiSdkDidReceiveSlience(_ userInfo: [AnyHashable : Any], fromGetui: Bool, offLine: Bool, appId: String?, taskId: String?, msgId: String?, fetchCompletionHandler completionHandler: ((UIBackgroundFetchResult) -> Void)? = nil) {
    let msg = "[ TestDemo ] \(#function) fromGetui:\(fromGetui ? "个推消息" : "APNs消息") appId:\(appId ?? "") offLine:\(offLine ? "离线" : "在线") taskId:\(taskId ?? "") msgId:\(msgId ?? "") userInfo:\(userInfo)"
    print(msg)
  }
  
  @available(iOS 10.0, *)
  func geTuiSdkNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
    // [ 参考代码，开发者注意根据实际需求自行修改 ]
  }
  
  
  //MARK: - 发送上行消息
  
  /// [ GTSDK回调 ] SDK收到sendMessage消息回调
  func geTuiSdkDidSendMessage(_ messageId: String, result: Int32) {
    let msg = "[ TestDemo ] \(#function) \(String(describing: messageId)), result=\(result)"
    print(msg)
  }
  
  
  //MARK: - 开关设置
  
  /// [ GTSDK回调 ] SDK设置推送模式回调
  func geTuiSdkDidSetPushMode(_ isModeOff: Bool, error: Error?) {
    if let error = error {
      print("[ TestDemo ] \(#function) error: \(error.localizedDescription)")
    }
    print("[ TestDemo ] \(#function): \(isModeOff ? "开启" : "关闭")")
//    homePage.updatePushMode(isModeOff)
  }
  
  
  //MARK: - 别名设置
  
  func geTuiSdkDidAliasAction(_ action: String, result isSuccess: Bool, sequenceNum aSn: String, error aError: Error?) {
    /*
     参数说明
     isSuccess: YES: 操作成功 NO: 操作失败
     aError.code:
     30001：绑定别名失败，频率过快，两次调用的间隔需大于 5s
     30002：绑定别名失败，参数错误
     30003：绑定别名请求被过滤
     30004：绑定别名失败，未知异常
     30005：绑定别名时，cid 未获取到
     30006：绑定别名时，发生网络错误
     30007：别名无效
     30008：sn 无效 */
    
    var msg = ""
    if action == kGtResponseBindType {
      msg = "[ TestDemo ] \(#function) bind alias result sn = \(String(describing: aSn)), error = \(String(describing: aError))"
    }
    if action == kGtResponseUnBindType {
      msg = "[ TestDemo ] \(#function) unbind alias result sn = \(String(describing: aSn)), error = \(String(describing: aError))"
    }
    print(msg)
  }
  
  
  //MARK: - 标签设置
  func geTuiSdkDidSetTagsAction(_ sequenceNum: String, result isSuccess: Bool, error aError: Error?) {
    /*
     参数说明
     sequenceNum: 请求的序列码
     isSuccess: 操作成功 YES, 操作失败 NO
     aError.code:
     20001：tag 数量过大（单次设置的 tag 数量不超过 100)
     20002：调用次数超限（默认一天只能成功设置一次）
     20003：标签重复
     20004：服务初始化失败
     20005：setTag 异常
     20006：tag 为空
     20007：sn 为空
     20008：离线，还未登陆成功
     20009：该 appid 已经在黑名单列表（请联系技术支持处理）
     20010：已存 tag 数目超限
     20011：tag 内容格式不正确
     */
    let msg = "[ TestDemo ] \(#function)  sequenceNum:\(sequenceNum) isSuccess:\(isSuccess) error: \(String(describing: aError))"
    print(msg)
  }
}

extension SdkStatus {
  var title: String {
    switch self {
    case .starting:
      return "正在启动"
    case .started:
      return "已启动"
    case .offline:
      return "已离线"
    default:
      return "已停止"
    }
  }
}

extension Notification.Name {
  public static let GTSDKState = Notification.Name(rawValue: "ent.com.getui.demo.GTSDKState")
}

extension UIAlertController {
  static func alert(title: String) {
    let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
    let sureAction = UIAlertAction(title: "确定", style: .default, handler: nil)
    alertController.addAction(sureAction)
//    if let delegate = UIApplication.shared.delegate as? AppDelegate {
//      delegate.homePage.present(alertController, animated: true, completion: nil)
//    }
  }
}

