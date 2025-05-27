//
//  ConfiguredWidgetButton.swift
//
//
//  Created by ByteDance on 2024/8/5.
//

import AppIntents
import SwiftUI
import WidgetKit
@available(iOS 18, *)
struct ConfiguredWidgetButton: ControlWidget {
    static let kind: String = "com.apple.ConfiguredWidgetButton"
    
    var body: some ControlWidgetConfiguration {
        AppIntentControlConfiguration(
            kind: Self.kind,
            provider: Provider()
        ) { value in
            ControlWidgetButton( action: openDifferentPageIntent(value.name)){
                Image(systemName: "lock.open")
                Text("open \(value.name) Page control")
            }
        }
        .displayName("open Different Page control")
        .description("A an example control that open Different Page")
        .promptsForUserConfiguration()
    }
}

@available(iOS 18, *)
extension ConfiguredWidgetButton {
    struct Value {
        var name: String
    }
    
    struct Provider: AppIntentControlValueProvider {
        func previewValue(configuration: ButtonUserConfiguration) -> Value {
            ConfiguredWidgetButton.Value(name: "My App")
        }
        
        func currentValue(configuration: ButtonUserConfiguration) async throws -> Value {
            return ConfiguredWidgetButton.Value(name: configuration.timerName ?? "inbox")
        }
    }
}

@available(iOS 18, *)
struct ButtonUserConfiguration: ControlConfigurationIntent {
    static var title: LocalizedStringResource { "Enter Scene Name Configuration" }
    
    
    struct FocusOptionsProvider: DynamicOptionsProvider {
        func results() async throws -> [String] {
            ["Scene1","Scene2","Scene3"]
        }
    }
    
    @Parameter(title: "Scene Name", optionsProvider: FocusOptionsProvider())
    var timerName: String?
}

@available(iOS 18, *)
struct openDifferentPageIntent: AppIntent {
    static var title: LocalizedStringResource { "open Different Page" }
    static var openAppWhenRun = true
    @Parameter(title: "Page Name")
    var name: String
    
    init() {}
    
    init(_ name: String) {
        self.name = name
    }
    
    func perform() async throws -> some IntentResult {
        print("enter scene name: \(self.name)")
        return .result()
    }
}



