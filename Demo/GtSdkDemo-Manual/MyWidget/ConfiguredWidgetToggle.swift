//
//  ConfiguredWidgetToggle.swift
//
//
//  Created by ByteDance on 2024/8/5.
//

import AppIntents
import SwiftUI
import WidgetKit
var runState: Bool = false

//针对不同的房间，设置不同的开关状态。 可以实现单个类型小组件拥有同的场景数据
var map = ["Room1":false,
           "Room2":false,
           "Room3":false]

func getCurrentStatus(_ roomName: String?) -> Bool {
    var status = false
    if let name = roomName {
        status = map[name] ?? false
    }
    NSLog("ControlsLog getCurrentStatus \(roomName ?? "") \(status)")
    return status
}


@available(iOS 18, *)
struct ConfiguredWidgetToggle: ControlWidget {
    static let kind: String = "com.apple.ConfiguredWidgetToggle"
    
    var body: some ControlWidgetConfiguration {
       AppIntentControlConfiguration(
            kind: Self.kind,
            provider: ConfiguredWidgetToggle.Provider()
        ) { value in
            
            // ：这是一个闭包，当获取到定时器状态时执行，其中 isRunning 表示当前的定时器状态。通过这种方式，你可以使控件动态响应定时器状态的变化，提供更好的用户体验。
            // 定义了一个切换控件，使用 isOn 属性表示当前的状态。 isOn 属性和操作意图 action。
            ControlWidgetToggle(
                "\(value.roomName),\(value.pageName)",
                // 绑定到 TimerManager.shared.isRunning，表示定时器是否在运行。
                isOn: getCurrentStatus(value.roomName),//runState,
                // 指定了一个 ToggleTimerIntent 操作，当用户点击控件时触发该操作。
                action: ConfiguredToggleIntent(value.pageName, value.roomName)//openDifferentPageIntent(value.pageName, value.roomName)
            ){ isOn in // 这是一个闭包，用于根据 isOn 的值动态更新控件的图标。
                
                // 图像控件，用于显示系统图标。根据 isOn 的值选择不同的图标。
                // Image(systemName: isOn ? "hourglass" : "hourglass.bottomhalf.filled")
                
                // 这是一个带有文本和图标的控件，用于显示控件的状态。
                Label(isOn ? "Running\(ControlsTimerManager.datestr())" : "Stopped\(ControlsTimerManager.datestr())", // 根据 isOn 的值选择显示文本，运行时显示“Running”，停止时显示“Stopped”。
                      systemImage: isOn // 根据 isOn 的值选择不同的图标。
                      ? "light.max"
                      : "light.min")
                // 这是一个方法，用于为控件添加操作提示，如“Start”或“Stop”。
                .controlWidgetActionHint(isOn ? "Start" : "Stop")
            }
            // 设置控件的主题色为紫色，使其更具视觉吸引力。
            .tint(.purple)
        }
        .displayName("switch Room control")
        .description("A an example control that switch Room control")
        .promptsForUserConfiguration()
    }
}

@available(iOS 18, *)
extension ConfiguredWidgetToggle {
    struct Value {
        var pageName: String
        var roomName: String
    }
    
    struct Provider: AppIntentControlValueProvider {
        func previewValue(configuration: UserConfiguration) -> Value {
            ConfiguredWidgetToggle.Value(pageName: "-Page-", roomName: "--Room--")
        }
        
        func currentValue(configuration: UserConfiguration) async throws -> Value {
            return ConfiguredWidgetToggle.Value(pageName: configuration.sceneName ?? "unknown", roomName:configuration.roomName ?? "unknown")
        }
    }
}

// 操作意图（Intent），用于处理定时器的启动和停止操作。定义了一个新的结构体，它实现了 SetValueIntent 和 LiveActivityIntent 协议。
@available(iOS 18, *)
struct ConfiguredToggleIntent: SetValueIntent, LiveActivityIntent {
    // 本地化字符串资源
    static var title: LocalizedStringResource = "ConfiguredWidgetToggle"
    // Parameter：这是一个参数注解，用于定义意图中的参数。
    // 一个布尔值，运行状态。
    @Parameter(title: "Toggle")
    var value: Bool
    
    @Parameter(title: "Page Name")
    var pname: String
    
    
    @Parameter(title: "Room Name")
    var rname: String
    
    init() {}
    
    
    init(_ name: String, _ name2: String) {
        self.pname = name
        self.rname = name2
    }
    
    
    // 定义了执行意图时的操作。
    func perform() async throws -> some IntentResult {
        NSLog("ControlsLog perform \(self.pname) \(self.rname) value:\(self.value) runState:\(runState)")
        // 刷新时间
        ControlsTimerManager.shared.setTimerRunning(value)
        
        //mock http
        //await ControlsWidgetToggle.requestHttp()
        
        //切换开关状态
        var status = map[self.rname]!
        status.toggle()
        map[self.rname] = status
        
        
        // 保存数据到Group App容器，传递给主应用
        if let appGroupDefaults = UserDefaults(suiteName: "group.ent.com.getui.demo") {
            if appGroupDefaults.bool(forKey: "ConfiguredWidgetToggle") {
                appGroupDefaults.set(false, forKey: "ConfiguredWidgetToggle")
            } else {
                appGroupDefaults.set(true, forKey: "ConfiguredWidgetToggle")
            }
        }
        
        // 返回一个结果，表示意图执行成功。
        NSLog("ControlsLog perform return \(self)")
        return .result()
    }
}

@available(iOS 18, *)
struct UserConfiguration: ControlConfigurationIntent {
    static var title: LocalizedStringResource { "Enter Page Name Configuration" }
    
    
    struct PageOptionsProvider: DynamicOptionsProvider {
        func results() async throws -> [String] {
            ["Page1","Page2","Page3"]
        }
    }
    
    struct RoomOptionsProvider: DynamicOptionsProvider {
        func results() async throws -> [String] {
            ["Room1","Room2","Room3"]
        }
    }
    
    @Parameter(title: "Scene Name", optionsProvider: PageOptionsProvider())
    var sceneName: String?
    
    
    @Parameter(title: "Room Name", optionsProvider: RoomOptionsProvider())
    var roomName: String?
}




