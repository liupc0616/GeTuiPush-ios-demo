//
//  TimerManager.swift
//  ControlWidget
//
//  Created by akak on 2024/11/19.

import SwiftUI
import Combine
import Foundation

class ControlsTimerManager: ObservableObject {
    static let shared = ControlsTimerManager()
    var isRunning = false

    private init() {}

    func setTimerRunning(_ value: Bool) {
        isRunning = value
    }

    func fetchRunningState() -> Bool {
        return isRunning
    }
    
    static func datestr() -> String {
     
        // 获取当前日期和时间
        let currentDate = Date()

        // 获取当前日历
        let calendar = Calendar.current

        // 从日期中提取小时和分钟
        let components = calendar.dateComponents([.hour, .minute, .second], from: currentDate)

        if let hour = components.hour, let minute = components.minute, let sec = components.second {
            return "\(hour):\(minute):\(sec)"
        }
        return "-"
    }
}
