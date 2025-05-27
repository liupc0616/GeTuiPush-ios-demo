//
//  LiveActivityUtils.swift
//  GtSdkDemo
//
//  Created by ak on 2022/11/21.
//
#if canImport(ActivityKit)
import Foundation
import ActivityKit


/**
 * [ 参考代码，开发者注意根据实际需求自行修改 ] Activity行为封装
 *
 * 警告：以下为参考代码, 注意根据实际需要修改.
 * 请参考苹果官方demo及官方文档进行开发 https://developer.apple.com/documentation/activitykit
 *
 */
@available(iOS 16.1, *)
@objcMembers
public class LiveActivityUtils : NSObject {
  static var pushTokenUpdate:((String?, String?, String?, Bool)->Void)?
  static var pushToStartTokenUpdates:((String?, String?)->Void)?
  
  static public func tokenUpdates(
    pushTokenUpdate:@escaping (String?, String?, String?, Bool)->Void,
    pushToStartTokenUpdates:@escaping (String?, String?)->Void) {
      
      
      //是否支持LA
      guard ActivityAuthorizationInfo().areActivitiesEnabled else {
        //不支持， 监听LA开关变化
        NSLog("Activity areActivitiesEnabled is disable")
        Task {
          for await enablment in ActivityAuthorizationInfo().activityEnablementUpdates {
            NSLog("Activity areActivitiesEnabled change to \(enablment)")
          }
        }
        return
      }
      
      //是否支持频繁更新
      if #available(iOS 16.2, *) {
        if !ActivityAuthorizationInfo().frequentPushesEnabled {
          Task {
            //不支持，监听，频繁更新这个标识的变更
            for await enablment in ActivityAuthorizationInfo().frequentPushEnablementUpdates {
              NSLog("Activity frequentPushesEnabled change to \(enablment)")
            }
          }
          NSLog("Activity frequentPushesEnabled disable")
        }
      } else {
        NSLog("Activity frequentPushesEnabled no support")
      }
      
      self.pushTokenUpdate = pushTokenUpdate
      self.pushToStartTokenUpdates = pushToStartTokenUpdates
      
      let attr1 = MyWidgetAttributes(name: "")
      let attr2 = MyWidgetAttributes2(name: "")
      
      //pushToStartToken
      getPushToStartToken(attributes: attr1)
      getPushToStartToken(attributes: attr2)
      
      getPushToken(attributes: attr1)
      getPushToken(attributes: attr2)
    }
  
  static public func startActivity1(activityId: String) {
    NSLog("startActivity1")
    let state = MyWidgetAttributes.ContentState(prograssState: .Car)
    let attri = MyWidgetAttributes(name: activityId)
    startActivity(activityId: activityId, attributes: attri, contentState: state)
  }
  
  static public func startActivity2(activityId: String) {
    NSLog("startActivity2")
    let state = MyWidgetAttributes2.ContentState(prograssState: .Car)
    let attri = MyWidgetAttributes2(name: activityId)
    startActivity(activityId: activityId, attributes: attri, contentState: state)
  }
  
  static func startChannelActivity<Attributes>(activityId: String,
                                               attributes: Attributes,
                                               contentState: Attributes.ContentState) where Attributes : ActivityAttributes {
#if swift(>=6)
    //需要使用xcode16
    NSLog("startChannelActivity")
    do {
      var current: Activity<Attributes>?
      if #available(iOS 18.0, *) {
        //通过App创建LA，并订阅Channel
        current = try Activity.request(attributes: attributes, contentState: contentState, pushType: .channel("v6PxWUV/Ee8AAMZW8MQ57g=="))
      }
      self.startActivity(activityId: activityId, activity: current)
    }
    catch(let error) {
      NSLog("Activity error=", error)
      pushTokenUpdate(nil, nil, false)
    }
#else
    
#endif
  }
  
  static func startActivity<Attributes>(activityId: String,
                                        attributes: Attributes,
                                        contentState: Attributes.ContentState) where Attributes : ActivityAttributes {
    do {
      let current = try Activity.request(attributes: attributes, contentState: contentState, pushType: .token)
      self.startActivity(activityId: activityId, activity: current)
    }
    catch(let error) {
      NSLog("Activity error=\(error)")
      pushTokenUpdate?(nil, nil, nil, false)
    }
  }
  
  static func startActivity<Attributes>(activityId: String,
                                        activity: Activity<Attributes>) where Attributes : ActivityAttributes {
    
    guard ActivityAuthorizationInfo().areActivitiesEnabled else {
      //不支持
      return
    }
    
    //endPreActivity() //终止上一个灵动岛
    
    //let state = MyWidgetAttributes.ContentState(prograssState: .Car)
    //let attri = MyWidgetAttributes(name: activityId)
    //let current2 = try? Activity.request(attributes: attributes, contentState: contentState, pushType: .token)
    let current = activity
    Task {
      //监听内容数据状态变化， contentState是视图对应的数据
      for await state in current.contentStateUpdates {
        NSLog("Activity content state update: tip=\(state)")
      }
    }
    Task {
      //监听视图的声明周期，状态变化：active，end，dismissed等
      for await state in current.activityStateUpdates {
        NSLog("Activity state update: tip=\(state) id:\(current.id)")
      }
    }
  }
  
  //更新Activity状态 也可通过APNs更新 交互
  static public func updateActivityState1(_ value: Int) {
    Task {
      guard let current = Activity<MyWidgetAttributes>.activities.last else {
        return
      }
      
      let state = MyWidgetAttributes.ContentState(prograssState: PrograssState(rawValue: value) ?? .Arrived)
      let alertConfiguration = AlertConfiguration(title: "Delivery Update ", body: "Delivery Update State to \(state.prograssState.rawValue)", sound: .default)
      await current.update(using: state, alertConfiguration: alertConfiguration)
    }
  }
  
  //更新Activity状态 也可通过APNs更新 交互
  static public func updateActivityState2(_ value: Int) {
    Task {
      guard let current = Activity<MyWidgetAttributes2>.activities.last else {
        return
      }
      
      let state = MyWidgetAttributes2.ContentState(prograssState: PrograssState2(rawValue: value) ?? .Arrived)
      let alertConfiguration = AlertConfiguration(title: "Delivery Update ", body: "Delivery Update State to \(state.prograssState.rawValue)", sound: .default)
      await current.update(using: state, alertConfiguration: alertConfiguration)
    }
  }
  
  //建议关闭应用的时候要关闭 不然下次启动就脱离控制了
  static public func endPreActivity1() {
    let activities = Activity<MyWidgetAttributes>.activities.filter { act in
      return act.activityState == .active
    }
    guard activities.count > 0 else { return }
    for item in activities {
      Task {
        NSLog("Activity end \(item.id)")
        await item.end(dismissalPolicy:.immediate)
      }
    }
  }
  
  static public func endPreActivity2() {
    let activities = Activity<MyWidgetAttributes2>.activities.filter { act in
      return act.activityState == .active
    }
    guard activities.count > 0 else { return }
    for item in activities {
      Task {
        NSLog("Activity end \(item.id)")
        await item.end(dismissalPolicy:.immediate)
      }
    }
  }
  
  //MARK: - Private
  
  //App启动后，pushToStartToken为空。需要创建la后，可以拿到pushToStartToken
  static func getPushToStartToken<Attributes>(attributes: Attributes) where Attributes : ActivityAttributes {
    if #available(iOS 17.2, *) {
      let tokenData = Activity<Attributes>.pushToStartToken
      if let token = tokenData {
        let pushToStartToken = String(data: token, encoding: .utf8)
        NSLog("Activity \(Attributes.self) pushToStartToken = \(String(describing: pushToStartToken))")
        pushToStartTokenUpdates?("\(Attributes.self)",pushToStartToken ?? "")
      }
      
      Task {
        for await tokenData in Activity<Attributes>.pushToStartTokenUpdates {
          //监听token更新 注意线程
          let mytoken = tokenData.map { String(format: "%02x", $0) }.joined()
          NSLog("Activity updates \(Attributes.self) pushToStartToken = \(mytoken) ")
          pushToStartTokenUpdates?("\(Attributes.self)",mytoken)
        }
      }
    }
  }
  
  //监听LA列表变化
  static func getPushToken<Attributes>(attributes: Attributes) where Attributes : ActivityAttributes {
    NSLog("Activity \(Attributes.self) list count: \(Activity<Attributes>.activities.count) list:\(Activity<Attributes>.activities)")
    
    Task {
      for await updates in Activity<Attributes>.activityUpdates {
        NSLog("Activity \(Attributes.self) list update count: \(Activity<Attributes>.activities.count)")
        
        NSLog("Activity \(Attributes.self) list update new:\(updates.id)")
        //TODO: 开发者上传新增的PushToken
        
        Task {
          var id: String = updates.id
          var la_id: String = ""
          if let activity = updates as? Activity<MyWidgetAttributes> {
            la_id = activity.attributes.name
          }
          if let activity = updates as? Activity<MyWidgetAttributes2> {
            la_id = activity.attributes.name
          }
          for await tokenData in updates.pushTokenUpdates {
            //监听token更新 注意线程
            let mytoken = tokenData.map { String(format: "%02x", $0) }.joined()
            NSLog("Activity \(Attributes.self) list update token=\(mytoken) id:\(updates.id) ")
            pushTokenUpdate?(la_id, id, mytoken, true)
          }
        }
      }
    }
  }
}
#endif
