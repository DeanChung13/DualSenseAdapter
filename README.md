# DualSenseAdapter

A lightweight macOS Menu Bar tool for monitoring PlayStation 5 DualSense controllers and converting button actions into keyboard events. Built with AppKit and GameController, it allows you to quickly customize mappings according to your needs.

[English](README.md) | 繁體中文

## Features
- Menu Bar icon with dropdown menu
- Auto-detect and connect DualSense controllers
- Logs button/axis value changes in Xcode console for easy debugging
- Trigger keyboard events from controller input (default: Options → "i")
- Supports background monitoring; receives controller events even when the app is not in the foreground
- Single-file centralized mapping management (`DualSenseManager.swift`)

## System Requirements
- macOS 11.5 (Big Sur) or later
- Xcode 15 or later (Swift 5.9+)
- A DualSense (PS5) controller (Bluetooth or USB)
- Accessibility permissions (required for sending keyboard events)

## Quick Start
1. Download or clone the project.
2. Open `DualSenseAdapter.xcodeproj` in Xcode.
3. Configure signing team if needed.
4. Build & Run.

After launching the app, you will see a controller icon in the Menu Bar. Press controller buttons, and the corresponding logs will appear in the Xcode console.

## Connecting a DualSense
- System Settings → Bluetooth → Pair your DualSense.
- Or connect via USB-C.

## Permissions (Accessibility)
This app uses `CGEvent` to send simulated keyboard events, which requires granting Accessibility permissions on macOS.

If no prompt appears automatically:
1. System Settings → Privacy & Security → Accessibility.
2. Click "+" to add the compiled app (or toggle permissions in the list).
3. Restart the app and try again.

Without authorization, simulated keyboard events will not reach other apps.

## How It Works
- `AppDelegate` creates the Menu Bar icon and starts scanning with `GCController`.
- `DualSenseManager` listens for controller connect/disconnect events and sets up various input handlers.
- In each handler, you can log events or call `simulateKeyPress(_:)` to send keyboard events.

Default example: pressing the Options button sends the letter `i`:
```swift
if #available(iOS 14.0, macOS 11.0, tvOS 14.0, *) {
    gamepad.buttonOptions?.valueChangedHandler = { [weak self] button, value, pressed in
        print("Options \(pressed ? \"pressed\" : \"released\")")
        if pressed {
            self?.simulateKeyPress("i")
        }
    }
}
```

## ☕ Support

If this project helps you, consider supporting me:  

<a href="https://www.buymeacoffee.com/wenway13" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>
