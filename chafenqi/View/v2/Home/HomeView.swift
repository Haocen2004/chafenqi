//
//  HomeView.swift
//  chafenqi
//
//  Created by 刘易斯 on 2023/5/7.
//

import SwiftUI
import AlertToast

struct HomeView: View {
    @Environment(\.managedObjectContext) var context
    @ObservedObject var user: CFQNUser
    @ObservedObject var alertToast = AlertToastModel.shared
    
    @State private var versionData = ClientVersionData.empty
    
    @AppStorage("settingsHomeArrangement") var homeArrangement = "最近动态|Rating分析|出勤记录"
    
    @State var refreshing = false
    @State var dismissed = false
    @State var daysSinceLastPlayed = 0
    
    var bundleVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    var bundleBuildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
    
    var body: some View {
        VStack {
            if (refreshing) {
                VStack {
                    ProgressView("刷新中...")
                }
            } else if (user.didLogin) {
                ScrollView {
                    HomeNameplate(user: user)
                    if daysSinceLastPlayed > 0 && user.showDaysSinceLastPlayed {
                        Text("你已经有\(daysSinceLastPlayed)天没出勤了！")
                            .bold()
                    }
                    ForEach(homeArrangement.components(separatedBy: "|"), id: \.hashValue) { value in
                        switch value {
                        case "最近动态":
                            HomeRecent(user: user)
                        case "Rating分析":
                            HomeRating(user: user)
                        case "出勤记录":
                            if user.isPremium {
                                HomeDelta(user: user)
                            }
                        default:
                            Spacer()
                        }
                    }
                }
                .navigationTitle("主页")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            Settings(user: user)
                        } label: {
                            Image(systemName: "gear")
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            refresh()
                        } label: {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                }
            }
        }
        .onAppear {
            var maiDay = 0
            var chuDay = 0
            if let recentOne = user.maimai.recent.sorted(by: { $0.timestamp > $1.timestamp }).first {
                maiDay = Calendar.current.dateComponents([.day], from: recentOne.timestamp.toDate(), to: Date()).day ?? 0
            }
            if let recentOne = user.chunithm.recent.sorted(by: { $0.timestamp > $1.timestamp }).first {
                chuDay = Calendar.current.dateComponents([.day], from: recentOne.timestamp.toDate(), to: Date()).day ?? 0
            }
            daysSinceLastPlayed = min(maiDay, chuDay)
            
            Task {
                do {
                    let versionRequest = URLRequest(url: URL(string: "http://43.139.107.206/chafenqi/version")!)
                    let (data, _) = try await URLSession.shared.data(for: versionRequest)
                    versionData = try JSONDecoder().decode(ClientVersionData.self, from: data)
                    if versionData.hasNewVersion(major: bundleVersion, minor: bundleBuildNumber) && !dismissed {
                        let updateAlert = Alert(
                            title: Text("发现新版本"),
                            message: Text("当前版本为：\(bundleVersion) Build \(bundleBuildNumber)\n最新版本为：\(versionData.major) Build \(versionData.minor)\n是否前往更新？"),
                            primaryButton: .default(Text("前往Testflight")) {
                                UIApplication.shared.open(URL(string: "itms-beta://testflight.apple.com/join/OBC08JvQ")!)
                            },
                            secondaryButton: .cancel(Text("取消")))
                        dismissed = true
                        alertToast.alert = updateAlert
                    }
                } catch {
                    versionData = .empty
                }
            }
        }
        .toast(isPresenting: $alertToast.show, duration: 1, tapToDismiss: true) {
            alertToast.toast
        }
        .alert(isPresented: $alertToast.alertShow) {
            alertToast.alert
        }
    }
    
    func refresh() {
        refreshing = true
        Task {
            do {
                try await user.refresh()
                refreshing = false
            } catch {
                let errToast = AlertToast(displayMode: .hud, type: .error(.red), title: "加载出错", subTitle: error.localizedDescription)
                alertToast.toast = errToast
                alertToast.show = true
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(user: CFQNUser())
    }
}
