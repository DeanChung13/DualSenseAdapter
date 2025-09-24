//
//  DualSenseAdapterApp.swift
//  DualSenseAdapter
//
//  Created by Dean Chung on 2025/9/24.
//

import SwiftUI

@main
struct DualSenseAdapterApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
