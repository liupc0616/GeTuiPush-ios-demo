//
//  LiveActivityAttributes.swift
//  GtSdkDemo
//
//  Created by  joy on 2022/11/24.
//  Copyright © 2022 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//

import ActivityKit

public struct LiveActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        //和aps中"content-state"字段映射
        var value: Int
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}
