//
//  ControlsCenterUtils.swift
//  GtSdkDemo
//
//  Created by ak on 2024/11/19.
//  Copyright © 2024 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//  常见问题：
//  - 如果安装app后，无法在控制中心搜索到对应的widget？ 需要尝试多次打开关闭app后再重试添加控制中心小组件
//  - token总是空？ 需确认当前target是否已经打开Push Notification能力

import Foundation
import WidgetKit
@available(iOS 18.0, *)
@objcMembers
public class ControlsCenterUtils: NSObject {
    public static func getTokens(_ callback: @escaping (Dictionary<String, String>)->Void) {
        Task {
            //刷新组件
            ControlCenter.shared.reloadAllControls()
            //ControlCenter.shared.reloadControls(ofKind: "com.apple.ControlWidgetButton")
            
            let controls = try await ControlCenter.shared.currentControls()
            
            NSLog("ControlsCenter widget count:\(controls.count)")
            var ret: [String: String] = [:]
            _ = controls.compactMap { info in
                var tokenStr = ""
                if let token: Data = info.pushInfo?.token {
                    for byte in token {
                        tokenStr += String(format: "%02X", byte)
                    }
                }
                ret[info.kind] = tokenStr
                NSLog("ControlsCenter widget id:\(info.id) info:\(info) token:\(String(describing: tokenStr))")
                return tokenStr
            }
            NSLog("ControlsCenter widget tokens: \(ret)")
            callback(ret)
        }
    }
}
