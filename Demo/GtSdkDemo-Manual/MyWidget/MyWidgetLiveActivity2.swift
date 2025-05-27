//
//  MyWidgetLiveActivity.swift
//  MyWidget
//
//  Created by ak on 2022/11/11.
//

#if canImport(ActivityKit)
import ActivityKit
import WidgetKit
import SwiftUI

public enum PrograssState2: Int, Codable, Hashable {
    case Car = 0
    case Storehouse
    case Package
    case Arrived
    
    func image() -> String {
        switch self {
        case .Car:
            return "figure.run"
        case .Storehouse:
            return "figure.archery"
        case .Package:
            return "figure.cooldown"
        case .Arrived:
            return "figure.curling"
        }
    }
    
    func desc() -> String {
        switch self {
        case .Car:
            return "In Car"
        case .Storehouse:
            return "In Storehouse"
        case .Package:
            return "Is Packageing"
        case .Arrived:
            return "Is Arrived"
        }
    }
    
}

public struct MyWidgetAttributes2: ActivityAttributes {
    
    public struct ContentState: Codable, Hashable {
        public var prograssState: PrograssState2
    }
    
    // Fixed non-changing properties about your activity go here!
    public var name: String
}

@available(iOS 16.4, *)
struct MyWidgetLiveActivity2: Widget {
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MyWidgetAttributes2.self) { context in
            // 在锁屏页 或者 通知列表页中展示。
            lockView(context)
                .activityBackgroundTint(context.isStale ? Color.red: Color.yellow)
                .activitySystemActionForegroundColor(Color.black)
            
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        Text(context.attributes.name)
                            .font(.subheadline)
                            .bold()
                        
                        MyViews.CirclrIcon("paperplane.fill", color: .clear)
                            .frame(width: 44, height: 44)
                        
                    }
                }

                DynamicIslandExpandedRegion(.trailing) {
                    HStack {
                        MyViews.CirclrIcon("shared.with.you", color: .blue)
                            .frame(width: 30, height: 30)
                            .padding(.leading, -15)
                        
                        MyViews.CirclrIcon("figure.walk.arrival", color: .purple)
                            .frame(width: 30, height: 30)
                            .padding(.leading, -15)
                        
                        MyViews.CirclrIcon("figure.wave", color: .orange)
                            .frame(width: 30, height: 30)
                            .padding(.leading, -15)
                    }
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    ZStack {
                        Divider()
                            .frame(height: 2)
                            .background(.black.opacity(0.5))
                            .background(in: Capsule())
                            .padding(.leading, 22)
                            .padding(.trailing, 22)
                        
                        HStack {
                            ForEach ([PrograssState2.Car,
                                      .Storehouse,
                                      .Package,
                                      .Arrived], id:\.self) { state in
                                          let choose = context.state.prograssState == state
                                          MyViews.CirclrIcon(state.image(), color:choose ? .orange : .cyan)
                                              .frame(width: 60, height: choose ? 40 : 30)
                                          
                                      }
                        }
                    }
                }
                
            } compactLeading: {
                Text(":)")
                    .font(.footnote)
                    .foregroundColor(.yellow)
            } compactTrailing: {
                Image(systemName:context.state.prograssState.image())
                
            } minimal: {
                Image(systemName:context.state.prograssState.image())
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(.red)
        }
    }
    
    
    @ViewBuilder
    func lockView(_ context: (ActivityViewContext<MyWidgetAttributes2>)) -> some View {
        VStack {
            HStack {
                HStack {
                    MyViews.CirclrIcon("paperplane.fill", color: .clear)
                        .frame(width: 44, height: 44)
                    
                    Text(context.attributes.name)
                        .font(.subheadline)
                        .bold()
                    
                }
                .padding(.leading, 5)
                
                Spacer()
                HStack {
                    MyViews.CirclrIcon("shared.with.you", color: .blue)
                        .frame(width: 30, height: 30)
                        .padding(.leading, -15)
                    
                    MyViews.CirclrIcon("figure.walk.arrival", color: .purple)
                        .frame(width: 30, height: 30)
                        .padding(.leading, -15)
                    
                    MyViews.CirclrIcon("figure.wave", color: .orange)
                        .frame(width: 30, height: 30)
                        .padding(.leading, -15)
                }
            }
            
            HStack {
                ZStack {
                    Divider()
                        .frame(height: 2)
                        .background(.black.opacity(0.5))
                        .background(in: Capsule())
                        .padding(.leading, 22)
                        .padding(.trailing, 22)
                    
                    HStack {
                        ForEach ([PrograssState2.Car,
                                  .Storehouse,
                                  .Package,
                                  .Arrived], id:\.self) { state in
                                      let choose = context.state.prograssState == state
                                      MyViews.CirclrIcon(state.image(), color:choose ? .orange : .cyan)
                                          .frame(width: 60, height: choose ? 40 : 30)
                                      
                                  }
                    }
                }
            }
            .padding(.top, 8)
        }
        .padding(10)
        .frame(height: 120)
    }
}
#endif
