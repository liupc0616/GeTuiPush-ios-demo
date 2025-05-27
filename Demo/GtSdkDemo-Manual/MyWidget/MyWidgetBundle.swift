//
//  MyWidgetBundle.swift
//  MyWidget
//
//  Created by ak on 2022/11/15.
//

import WidgetKit
import SwiftUI

@main
struct MyWidgetBundle: WidgetBundle {
    var body: some Widget {
        //桌面组件
        MyWidget()
        
        //实时活动
#if canImport(ActivityKit)
        MyWidgetLiveActivity()
        MyWidgetLiveActivity2()
#endif
        //控制中心
        if #available(iOS 18.0, *) {
            // 类型一：Toggles：切换控件，切换开关状态。
            ControlsWidgetToggle()
            
            // 类型二：Buttons：执行离散操作，打开App。
            ControlsWidgetButton()
            
            // 类型三：可选择配置的Button
            ConfiguredWidgetButton()
            
            // 类型四：可选择配置的Toggle
            ConfiguredWidgetToggle()
        }
    }
}
