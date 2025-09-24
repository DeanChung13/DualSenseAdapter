//
//  DualSenseManager.swift
//  DualSenseAdapter
//
//  Created by Dean Chung on 2025/9/24.
//

import Foundation
import Observation
import GameController

@Observable
class DualSenseManager {
    
    init() {
        // Observe controller connection
        NotificationCenter.default.addObserver(
            forName: .GCControllerDidConnect,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            if let controller = notification.object as? GCController {
                print("Controller connected: \(controller.vendorName ?? "Unknown")")
                self?.setupController(controller)
            }
        }
        
        // Observe controller disconnection
        NotificationCenter.default.addObserver(
            forName: .GCControllerDidDisconnect,
            object: nil,
            queue: .main
        ) { _ in
            print("Controller disconnected")
        }
        
        NotificationCenter.default.addObserver(
            forName: .GCControllerDidBecomeCurrent,
            object: nil,
            queue: .main
        ) { _ in
            print("Controller become current")
        }
        
        NotificationCenter.default.addObserver(
            forName: .GCControllerDidStopBeingCurrent,
            object: nil,
            queue: .main
        ) { _ in
            print("Controller stop being current")
        }
        
        GCController.shouldMonitorBackgroundEvents = true
    }
    
    // Configure button events
    func setupController(_ controller: GCController) {
        guard let gamepad = controller.extendedGamepad else { return }
        
        // ABXY buttons
        gamepad.buttonA.valueChangedHandler = { button, value, pressed in
            print("A \(pressed ? "pressed" : "released") value=\(value)")
        }
        gamepad.buttonB.valueChangedHandler = { button, value, pressed in
            print("B \(pressed ? "pressed" : "released") value=\(value)")
        }
        gamepad.buttonX.valueChangedHandler = { button, value, pressed in
            print("X \(pressed ? "pressed" : "released") value=\(value)")
        }
        gamepad.buttonY.valueChangedHandler = { button, value, pressed in
            print("Y \(pressed ? "pressed" : "released") value=\(value)")
        }
        
        // Shoulder buttons L1/R1
        gamepad.leftShoulder.valueChangedHandler = { button, value, pressed in
            print("L1 \(pressed ? "pressed" : "released") value=\(value)")
        }
        gamepad.rightShoulder.valueChangedHandler = { button, value, pressed in
            print("R1 \(pressed ? "pressed" : "released") value=\(value)")
        }
        
        // Triggers L2/R2
        gamepad.leftTrigger.valueChangedHandler = { button, value, pressed in
            print("L2 \(pressed ? "pressed" : "released") value=\(value)")
        }
        gamepad.rightTrigger.valueChangedHandler = { button, value, pressed in
            print("R2 \(pressed ? "pressed" : "released") value=\(value)")
        }
        
        // D-Pad (listen to axes and individual directions)
        gamepad.dpad.valueChangedHandler = { dpad, x, y in
            print("DPad axes: x=\(x), y=\(y)")
        }
        gamepad.dpad.up.valueChangedHandler = { button, value, pressed in
            print("DPad Up \(pressed ? "pressed" : "released") value=\(value)")
        }
        gamepad.dpad.down.valueChangedHandler = { button, value, pressed in
            print("DPad Down \(pressed ? "pressed" : "released") value=\(value)")
        }
        gamepad.dpad.left.valueChangedHandler = { button, value, pressed in
            print("DPad Left \(pressed ? "pressed" : "released") value=\(value)")
        }
        gamepad.dpad.right.valueChangedHandler = { button, value, pressed in
            print("DPad Right \(pressed ? "pressed" : "released") value=\(value)")
        }
        
        // Left and right thumbstick axes
        gamepad.leftThumbstick.valueChangedHandler = { dpad, x, y in
            print("Left stick: x=\(x), y=\(y)")
        }
        gamepad.rightThumbstick.valueChangedHandler = { dpad, x, y in
            print("Right stick: x=\(x), y=\(y)")
        }
        
        // Thumbstick buttons L3/R3 (if available on the controller)
        if let l3 = gamepad.leftThumbstickButton {
            l3.valueChangedHandler = { button, value, pressed in
                print("L3 \(pressed ? "pressed" : "released") value=\(value)")
            }
        }
        if let r3 = gamepad.rightThumbstickButton {
            r3.valueChangedHandler = { button, value, pressed in
                print("R3 \(pressed ? "pressed" : "released") value=\(value)")
            }
        }
        
        // System-related buttons (device/controller dependent)
        gamepad.buttonMenu.valueChangedHandler = { button, value, pressed in
            print("Menu \(pressed ? "pressed" : "released")")
        }
        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, *) {
            gamepad.buttonOptions?.valueChangedHandler = { [weak self] button, value, pressed in
                print("Options \(pressed ? "pressed" : "released")")
                if pressed {
                    self?.simulateKeyPress("i")
                }
            }
            gamepad.buttonHome?.valueChangedHandler = { button, value, pressed in
                print("Home \(pressed ? "pressed" : "released")")
            }
        }
    }
    
    // Simulate keyboard key press
    func simulateKeyPress(_ key: String) {
        DispatchQueue.main.async {
            let source = CGEventSource(stateID: .combinedSessionState)
            let keyCode = self.keyCode(for: key)
            let keyDown = CGEvent(keyboardEventSource: source, virtualKey: keyCode, keyDown: true)
            let keyUp = CGEvent(keyboardEventSource: source, virtualKey: keyCode, keyDown: false)
            keyDown?.post(tap: .cghidEventTap)
            keyUp?.post(tap: .cghidEventTap)
        }
    }
    
    // Map letters to macOS virtual key codes
    func keyCode(for char: String) -> CGKeyCode {
        switch char.lowercased() {
        case "a": return 0
        case "b": return 11
        case "c": return 8
        case "d": return 2
        case "e": return 14
        case "f": return 3
        case "g": return 5
        case "h": return 4
        case "i": return 34
        case "j": return 38
        case "k": return 40
        case "l": return 37
        case "m": return 46
        case "n": return 45
        case "o": return 31
        case "p": return 35
        case "q": return 12
        case "r": return 15
        case "s": return 1
        case "t": return 17
        case "u": return 32
        case "v": return 9
        case "w": return 13
        case "x": return 7
        case "y": return 16
        case "z": return 6
        default: return 0xFFFF
        }
    }
}

