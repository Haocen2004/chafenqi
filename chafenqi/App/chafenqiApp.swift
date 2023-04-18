//
//  chafenqiApp.swift
//  chafenqi
//
//  Created by 刘易斯 on 2023/1/6.
//

import SwiftUI
import NetworkExtension

var credits = """
特别感谢：
@SoreHait
@Diving-Fish - 舞萌DX/中二节奏查分器
@bakapiano - 查分器更新方案
sdvx.in - 谱面预览
And You
"""

private let quickActionService = QuickActionService.shared
let sharedContainer = UserDefaults(suiteName: "group.com.nltv.chafenqi.shared")!

@main
struct chafenqiApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var user = CFQUser.loadFromCache()
    
    @State var currentTab: TabIdentifier = .home
    @State var shouldRefresh = false
    
    @ObservedObject var service = TunnelManagerService.shared
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            MainView(user: user, currentTab: $currentTab)
                .onOpenURL { url in
                    guard let identifier = url.tabIdentifier else { return }
                    
                    currentTab = identifier
                }
                .onContinueUserActivity("StartProxyIntent", perform: { activity in
                    print("Starting proxy in main app")
                    guard let manager = loadProxyManager() else {
                        return
                    }
                    manager.loadFromPreferences { _ in
                        manager.isEnabled = true
                        manager.saveToPreferences { _ in
                            do {
                                try manager.connection.startVPNTunnel()
                            } catch {
                                print("Failed to start proxy.")
                                print(error)
                            }
                        }
                    }
                })
                .onContinueUserActivity("StopProxyIntent", perform: { activity in
                    print("Stopping proxy in main app")
                    guard let manager = loadProxyManager() else {
                        return
                    }
                    manager.connection.stopVPNTunnel()
                })
                .onChange(of: scenePhase, perform: { newValue in
                    switch newValue {
                    case .active:
                        performActionIfNeeded()
                    default:
                        break
                    }
                })
        }
    }
    
    func loadProxyManager() -> NETunnelProviderManager? {
        var failToLoad = false
        service.loadProfile { result in
            switch result {
            case .success(_):
                failToLoad = false
            case .failure(_):
                failToLoad = true
            }
        }
        guard !failToLoad, let manager = service.manager else {
            return nil
        }
        return manager
    }
    
    func performActionIfNeeded() {
      guard let action = quickActionService.action else { return }

      switch action {
      case .oneClickUpload:
          let shortcutName = "一键传分".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
          UIApplication.shared.open(URL(string: "shortcuts://run-shortcut?name=\(shortcutName)")!)
      }

      quickActionService.action = nil
    }

}

enum TabIdentifier: Hashable {
    case home, recent, list, tool
}

extension URL {
    var isDeeplink: Bool {
        return scheme == "chafenqi"
    }
    
    var tabIdentifier: TabIdentifier? {
        guard isDeeplink else { return nil }
        
        switch host {
        case "home": return .home
        case "recent": return .recent
        case "list": return .list
        case "tool": return .tool
        default: return nil
        }
    }
}
