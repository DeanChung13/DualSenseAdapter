//
//  AppDelegate.swift
//  DualSenseAdapter
//
//  Created by Dean Chung on 2025/9/24.
//

import AppKit
import GameController

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    let dualSenseManager = DualSenseManager()

    func applicationDidFinishLaunching(_ notification: Notification) {
        // 建立 Menu Bar icon
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "gamecontroller", accessibilityDescription: "DualSense")
        }
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q"))
        statusItem.menu = menu
        
        GCController.startWirelessControllerDiscovery(completionHandler: nil)
    }
    
    @objc func quit() {
        NSApplication.shared.terminate(nil)
    }
}
