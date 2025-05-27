//
//  LiveActivityLiveActivity.swift
//  LiveActivity
//
//  Created by  joy on 2022/11/24.
//  Copyright © 2022 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct LiveActivityLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text(String(context.state.value) + " " + context.attributes.name)
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.center) {
                    Image("Icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 44, height: 44)
                    .cornerRadius(22)
                }
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading" + String(context.state.value))
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing" + String(context.state.value))
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom" + context.attributes.name)
                    // more content
                }
            } compactLeading: {
                Text("L" + String(context.state.value))
            } compactTrailing: {
                Text("T" + String(context.state.value))
            } minimal: {
                Text("Min" + context.attributes.name)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}
