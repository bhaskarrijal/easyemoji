//
//  SettingsView.swift
//  easyemoji
//
//  Created by Bhaskar Rijal on 17/02/2026.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("holdDuration") private var holdDuration: Double = 0.4
    @State private var launchAtLogin: Bool = LaunchAgentManager.isLaunchAgentEnabled()
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack(alignment: .center) {
                Image(systemName: "globe")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.accentColor)
                
                Text("Easy Emoji")
                    .font(.headline)
                
                Spacer()
                
                Button(action: {
                    NSApplication.shared.terminate(nil)
                }) {
                    Text("Quit")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Hold Duration")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Text(String(format: "%.2fs", holdDuration))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(4)
                    }
                    
                    Slider(value: $holdDuration, in: 0.15...1.0, step: 0.05) {
                        EmptyView()
                    } minimumValueLabel: {
                        Image(systemName: "hare.fill")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    } maximumValueLabel: {
                        Image(systemName: "tortoise.fill")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Divider()
                    .opacity(0.5)
                
                HStack {
                    Text("Start at Login")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Toggle("", isOn: $launchAtLogin)
                        .toggleStyle(.switch)
                        .controlSize(.small)
                        .tint(.accentColor)
                        .onChange(of: launchAtLogin) { newValue in
                            if newValue {
                                LaunchAgentManager.createLaunchAgent()
                            } else {
                                LaunchAgentManager.removeLaunchAgent()
                            }
                        }
                }
            }
            .padding(16)
            
            HStack(alignment: .top, spacing: 8) {
                Text("Short tap switches input language. Press and hold to open the emoji picker.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
            
            Divider()
                .opacity(0.5)
            
            HStack(spacing: 4) {
                Text("Built by")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                
                Link("Bhaskar", destination: URL(string: "https://bhaskarrijal.me")!)
                    .font(.caption2)
                    .fontWeight(.light)
                    .underline()
                    .foregroundStyle(.secondary)
                    .onHover { inside in
                        if inside { NSCursor.pointingHand.push() }
                        else { NSCursor.pop() }
                    }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color(nsColor: .controlBackgroundColor).opacity(0.3))
        }
        .frame(width: 300)
        .fixedSize()
        .background(VisualEffectBlur(material: .popover, blendingMode: .behindWindow))
    }
}

struct LaunchAgentManager {
    static let label = "com.bhaskarrijal.easyemoji"
    
    static var plistPath: URL? {
        FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first?
            .appendingPathComponent("LaunchAgents")
            .appendingPathComponent("\(label).plist")
    }
    
    static func isLaunchAgentEnabled() -> Bool {
        guard let path = plistPath else { return false }
        return FileManager.default.fileExists(atPath: path.path)
    }
    
    static func createLaunchAgent() {
        guard let plistPath = plistPath else { return }
        
        let executablePath = Bundle.main.executablePath ?? ""
        
        let plistContent = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>Label</key>
            <string>\(label)</string>
            <key>ProgramArguments</key>
            <array>
                <string>\(executablePath)</string>
            </array>
            <key>RunAtLoad</key>
            <true/>
            <key>KeepAlive</key>
            <false/>
        </dict>
        </plist>
        """
        
        do {
            try FileManager.default.createDirectory(at: plistPath.deletingLastPathComponent(), withIntermediateDirectories: true)
            try plistContent.write(to: plistPath, atomically: true, encoding: .utf8)
        } catch {
            print("Failed to create launch agent: \(error)")
        }
    }
    
    static func removeLaunchAgent() {
        guard let plistPath = plistPath else { return }
        try? FileManager.default.removeItem(at: plistPath)
    }
}

struct VisualEffectBlur: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}
