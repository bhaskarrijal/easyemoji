//
//  easyemojiApp.swift
//  easyemoji
//
//  Created by Bhaskar Rijal on 17/02/2026.
//

import SwiftUI
import AppKit

@main
struct GlobeEmojiToolApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        Settings { EmptyView() }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover?
    var holdTimer: Timer?
    
    var holdDuration: TimeInterval {
        let saved = UserDefaults.standard.double(forKey: "holdDuration")
        return saved == 0 ? 0.4 : saved
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let popover = NSPopover()
        popover.behavior = .transient
        popover.animates = true
        
        let controller = NSHostingController(rootView: SettingsView())
        popover.contentViewController = controller
        
        self.popover = popover
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "globe", accessibilityDescription: "Globe Key")
            button.action = #selector(togglePopover(_:))
        }
        
        setupKeyboardListener()
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = statusItem?.button {
            if popover?.isShown == true {
                popover?.performClose(sender)
            } else {
                popover?.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                
                DispatchQueue.main.async {
                    NSApp.activate(ignoringOtherApps: true)
                }
            }
        }
    }
    
    // kbd listener
    func setupKeyboardListener() {
        NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) { [weak self] event in
            guard let self = self else { return }
            if event.keyCode == 63 {
                if event.modifierFlags.contains(.function) {
                    self.startHoldTimer()
                } else {
                    self.cancelHoldTimer()
                }
            }
        }
    }
    
    func startHoldTimer() {
        holdTimer?.invalidate()
        holdTimer = Timer.scheduledTimer(withTimeInterval: self.holdDuration, repeats: false) { [weak self] _ in
            self?.simulateEmojiShortcut()
        }
    }
    
    func cancelHoldTimer() {
        holdTimer?.invalidate()
    }

    func simulateEmojiShortcut() {
        DispatchQueue.main.async {
            let source = CGEventSource(stateID: .hidSystemState)
            let spaceKey: CGKeyCode = 49
            
            if let eventDown = CGEvent(keyboardEventSource: source, virtualKey: spaceKey, keyDown: true) {
                eventDown.flags = [.maskCommand, .maskControl]
                eventDown.post(tap: .cghidEventTap)
            }
            if let eventUp = CGEvent(keyboardEventSource: source, virtualKey: spaceKey, keyDown: false) {
                eventUp.flags = [.maskCommand, .maskControl]
                eventUp.post(tap: .cghidEventTap)
            }
        }
    }
}
