//
//  WidgetButton.swift
//  ControlWidget
//
//  Created by akak on 2024/11/19.

import Foundation
import WidgetKit
import SwiftUI
import AppIntents
import UIKit
import Combine

// 使用 ControlWidget 协议来定义一个基础控件,定义了一个新的结构体 WidgetToggle，它实现了 ControlWidget 协议。
@available(iOS 18.0, *)
struct ControlsWidgetButton: ControlWidget {
    // body属性表示该 WidgetButton 中包含的控件列表。
    var body: some ControlWidgetConfiguration {
        // // 这是一个静态配置，用于定义控件的结构：外观和行为。
        
        StaticControlConfiguration(
            kind: "com.apple.ControlWidgetButton"
        ) {
            // 定义了一个打开容器App的控件，
            ControlWidgetButton(action: OpenContainerAction()) {
                Label("WidgetButton", systemImage: "paperplane")
            } actionLabel: { isActive in
                if isActive {
                    Label("WidgetButton", systemImage: "hourglass")
                }
            }
        }
        .displayName("GTSDK")
        .description("The GTSDK Demo Application")
        .pushHandler(ControlWidgetPushHandler.self)
    }
}

@available(iOS 18, *)
struct OpenContainerAction: AppIntent {
    // 本地化字符串资源
    static let title: LocalizedStringResource = "WidgetButton"
    
    // 若要打开app，1 openAppWhenRun必须设置true 2 当前文件需要添加App到target
    static var openAppWhenRun: Bool = true
    
    // 定义了执行意图时的操作。
    func perform() async throws -> some IntentResult & OpensIntent {
        NSLog("ControlsLog WidgetButton perform")
        // 保存数据到Group App容器，传递给主应用
        if let appGroupDefaults = UserDefaults(suiteName: "group.ent.com.getui.demo") {
            NSLog("ControlsLog WidgetButton update ud")
            if appGroupDefaults.bool(forKey: "widgetExtensionData") {
                appGroupDefaults.set(false, forKey: "widgetExtensionData")
            } else {
                appGroupDefaults.set(true, forKey: "widgetExtensionData")
            }
        }
        //await xxx //这里可以同步等待App的某些操作
        
        //无任何返回
        //return .result()
        
        // 打开容器App
        return .result(opensIntent: OpenURLIntent(URL(string: "gtsdk://WidgetButton")!))
    }
}

@available(iOS 18, *)
struct ControlWidgetPushHandler: ControlPushHandler {
    func pushTokensDidChange(controls: [ControlInfo]) {
        NSLog("ControlsLog WidgetButton pushTokensDidChange \(controls)")
        let pushTokens = controls.compactMap { $0.pushInfo?.token }
        
        NSLog("ControlsLog WidgetButton pushTokensDidChange pushTokens:\(pushTokens)")
        if let deviceToken = pushTokens.first {
            // Register with Firebase Hub
            let logMessage = "WidgetButton Remote device token received for control widget: \(String(data: deviceToken, encoding: .utf8) ?? "")"
            NSLog("ControlsLog WidgetButton \(logMessage)")
            //Messaging.messaging().apnsToken = deviceToken
        }
    }
}
