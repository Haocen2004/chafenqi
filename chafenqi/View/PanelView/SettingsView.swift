//
//  SettingsView.swift
//  chafenqi
//
//  Created by 刘易斯 on 2023/1/9.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("settingsCoverSource") var coverSource = 0
    @AppStorage("settingsCurrentMode") var currentMode = 0
    
    @AppStorage("userAccountName") var accountName = ""
    @AppStorage("userNickname") var accountNickname = ""
    @AppStorage("userToken") var token = ""
    @AppStorage("userTokenHeader") var tokenHeader = ""
    @AppStorage("userInfoData") var infoData = Data()
    
    @AppStorage("didLogin") var didLogin = false
    
    @State private var accountPassword = ""
    @State private var showingLoginView = false
    @State private var showingBuildNumber = false
    @State private var loading = false
    
    @Binding var showingSettings: Bool
    
    var sourceOptions = [0: "Github", 1: "Gitee"]
    var modeOptions = [0: "中二节奏NEW", 1: "舞萌DX"]
    var bundleVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    var bundleBuildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("封面来源")
                        Spacer()
                        Picker("", selection: $coverSource) {
                            ForEach(sourceOptions.sorted(by: <), id: \.key) {
                                Text($0.value)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                } header: {
                    Text("常规")
                } footer: {
                    Text("Gitee暂不可用")
                }
                
                Section {
                    if (didLogin) {
                        TextInfoView(text: "用户名", info: accountName)
                        TextInfoView(text: "Token", info: token)
                        HStack {
                            Text("当前数据来源")
                            Spacer()
                            Picker("", selection: $currentMode) {
                                ForEach(modeOptions.sorted(by: <), id: \.key) {
                                    Text($0.value)
                                }
                            }
                            .pickerStyle(.menu)
                        }
                        Button {
                            clearUserCache()
                            didLogin.toggle()
                        } label: {
                            Text("登出")
                                .foregroundColor(Color.red)
                        }
                    } else {
                        TextField("用户名", text: $accountName)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                        SecureField("密码", text: $accountPassword)
                        HStack {
                            Button {
                                Task {
                                    do {
                                        loading.toggle()
                                        (tokenHeader, token) = try await ProbeDataGrabber.loginAs(username: accountName, password: accountPassword)
                                        didLogin.toggle()
                                        showingSettings.toggle()
                                    } catch CFQError.AuthenticationFailedError {
                                    } catch {
                                        
                                    }
                                    loading.toggle()
                                }
                            } label: {
                                Text("登录")
                            }
                            if (loading) {
                                Spacer()
                                
                                ProgressView()
                            }
                        }
                    }
                } header: {
                    Text("账户")
                }
                
                Section {
                    NavigationLink {
                        RandomizerSettingsView()
                    } label: {
                        Text("随机歌曲")
                    }
                } header: {
                    Text("工具")
                }
                
                Section {
                    HStack {
                        Text("版本")
                        Spacer()
                        Text("\(bundleVersion) \(showingBuildNumber ? "Build \(bundleBuildNumber)" : "")")
                            .foregroundColor(Color.gray)
                            .onTapGesture {
                                showingBuildNumber.toggle()
                            }
                    }
                    
                    Link("到Github提交反馈...", destination: URL(string: "https://github.com/Louiswu2011/chafenqi/issues")!)
                    
                    Button() {
                        
                    } label: {
                        Text("请作者打一把中二")
                    }.disabled(true)
                } header: {
                    Text("关于")
                } footer: {
                    Text(credits)
                }
            }
            .navigationTitle("设置")
        }
    }
    
    func clearUserCache(){
        accountName = ""
        accountPassword = ""
        accountNickname = ""
        tokenHeader = ""
        token = ""
        infoData = Data()
    }
}

struct RandomizerSettingsView: View {
    @AppStorage("settingsRandomizerFilterMode") var filterMode = 0
    
    let filterOptions = [0: "无", 1: "仅未游玩歌曲", 2: "仅已游玩歌曲"]
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("筛选模式")
                    Spacer()
                    Picker("", selection: $filterMode) {
                        ForEach(filterOptions.sorted(by: <), id: \.key) {
                            Text($0.value)
                        }
                    }
                    .pickerStyle(.menu)
                }
            } header: {
                Text("常规")
            }
        }
        .navigationTitle("随机歌曲")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showingSettings: .constant(true))
    }
}
