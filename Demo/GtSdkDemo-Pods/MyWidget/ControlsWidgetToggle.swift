//
//  WidgetToggle.swift
//  ControlWidget
//
//  Created by akak on 2024/11/19.

import Foundation
import WidgetKit
import SwiftUI
import AppIntents
import UIKit
import Combine
import Intents

// 使用 ControlWidget 协议来定义一个基础控件,定义了一个新的结构体 WidgetToggle，它实现了 ControlWidget 协议。

@available(iOS 18, *)
struct ControlsWidgetToggle: ControlWidget {
    // body属性表示该 WidgetToggle 中包含的控件列表。
    var body: some ControlWidgetConfiguration {
        // 这是一个静态配置，用于定义控件的结构：外观和行为。
        StaticControlConfiguration(
            // 指定控件的唯一标识符
            kind: "com.apple.ControlWidgetToggle",
            // 使用定义的 TimerValueProvider 作为值提供者。
            provider: TimerValueProvider()
        ) { isRunning in
            // ：这是一个闭包，当获取到定时器状态时执行，其中 isRunning 表示当前的定时器状态。通过这种方式，你可以使控件动态响应定时器状态的变化，提供更好的用户体验。
            // 定义了一个切换控件，使用 isOn 属性表示当前的状态。 isOn 属性和操作意图 action。
            ControlWidgetToggle(
                "GTSDK",
                // 绑定到 TimerManager.shared.isRunning，表示定时器是否在运行。
                isOn: isRunning,
                // 指定了一个 ToggleTimerIntent 操作，当用户点击控件时触发该操作。
                action: ToggleTimerIntent()
            ){ isOn in // 这是一个闭包，用于根据 isOn 的值动态更新控件的图标。

                // 图像控件，用于显示系统图标。根据 isOn 的值选择不同的图标。
                // Image(systemName: isOn ? "hourglass" : "hourglass.bottomhalf.filled")

                // 这是一个带有文本和图标的控件，用于显示控件的状态。
                Label(isOn ? "Running\(ControlsTimerManager.datestr())" : "Stopped\(ControlsTimerManager.datestr())", // 根据 isOn 的值选择显示文本，运行时显示“Running”，停止时显示“Stopped”。
                      systemImage: isOn // 根据 isOn 的值选择不同的图标。
                      ? "hourglass.bottomhalf.filled"
                      : "hourglass")
                // 这是一个方法，用于为控件添加操作提示，如“Start”或“Stop”。
                .controlWidgetActionHint(isOn ? "Start" : "Stop")
            }
            // 设置控件的主题色为紫色，使其更具视觉吸引力。
            .tint(.purple)
        }
        // 设置控件的显示名称为“GTSDK”。
        .displayName("GTSDK \(ControlsTimerManager.datestr())")
        // 添加控件的描述。
        .description("The GTSDK Demo application")
        .pushHandler(ControlWidgetPushHandler.self)
    }
}

@available(iOS 18, *)
extension ControlsWidgetToggle {
    static func requestHttp() async {
        // 创建 URL
        let url = URL(string: "https://www.baidu.com")!
        
        // 创建 URLRequest
        let request = URLRequest(url: url)
        
        do {
            // 发送请求并等待响应
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // 处理响应数据
            if let httpResponse = response as? HTTPURLResponse {
                NSLog("ControlsLog HTTP Status Code: \(httpResponse.statusCode)")
            }
            
            // 打印响应数据
            if let dataString = String(data: data, encoding: .utf8) {
                NSLog("ControlsLog HTTP Response Data: \(dataString)")
            }
        } catch {
            // 处理错误
            NSLog("ControlsLog HTTP Error: \(error)")
        }
    }
}

// 定义了一个新的结构体 TimerValueProvider，它实现了 ControlValueProvider 协议。
@available(iOS 18, *)
struct TimerValueProvider: ControlValueProvider {
    // 这是一个异步函数，用于获取当前的定时器状态。
    func currentValue() async throws -> Bool {
        // 获取定时器的运行状态。
        NSLog("ControlsLog currentValue")
        await ControlsWidgetToggle.requestHttp()
        
        NSLog("ControlsLog currentValue return")
        return ControlsTimerManager.shared.fetchRunningState()
    }

    // 定义了一个预览值，当无法获取实际值时使用。
    var previewValue: Bool {
      return false
    }
}

// 操作意图（Intent），用于处理定时器的启动和停止操作。定义了一个新的结构体，它实现了 SetValueIntent 和 LiveActivityIntent 协议。
@available(iOS 18, *)
struct ToggleTimerIntent: SetValueIntent, LiveActivityIntent {
    // 本地化字符串资源
    static var title: LocalizedStringResource = "WidgetToggle"
    // Parameter：这是一个参数注解，用于定义意图中的参数。
    // title：参数的标题。
    @Parameter(title: "Toggle")
    // 一个布尔值，表示定时器的运行状态。
    var value: Bool
    // 定义了执行意图时的操作。
    func perform() async throws -> some IntentResult {
        NSLog("ControlsLog perform \(self)")
        // 切换保存开关状态，调用 TimerManager 来设置定时器的运行状态。
        ControlsTimerManager.shared.setTimerRunning(value)
        
        
        await ControlsWidgetToggle.requestHttp()
        
        // 保存数据到Group App容器，传递给主应用
        if let appGroupDefaults = UserDefaults(suiteName: "group.ent.com.getui.demo") {
            if appGroupDefaults.bool(forKey: "widgetExtensionData") {
                appGroupDefaults.set(false, forKey: "widgetExtensionData")
            } else {
                appGroupDefaults.set(true, forKey: "widgetExtensionData")
            }
        }
        // 返回一个结果，表示意图执行成功。
        NSLog("ControlsLog perform return\(self)")
        return .result()
    }
}
