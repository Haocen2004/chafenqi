//
//  HomeTopView.swift
//  chafenqi
//
//  Created by 刘易斯 on 2023/3/9.
//

import SwiftUI

struct HomeTopView: View {
    @ObservedObject var user: CFQNUser
    
    var body: some View {
        Group {
            ScrollView {
                NamePlateView(user: user)
                Group {
                    HStack {
                        Text("最近动态")
                            .font(.system(size: 20))
                            .bold()
                        Spacer()
                        
                        NavigationLink {
                            RecentView(user: user)
                        } label: {
                            Text("显示全部")
                                .font(.system(size: 18))
                        }
                        .disabled(user.currentMode == 0 ? user.chunithm.isEmpty : user.maimai.isEmpty)
                    }
                    .padding(.horizontal)
                    
                    
                    HStack {
                        if ((user.currentMode == 1 && user.maimai.isEmpty) || (user.currentMode == 0 && user.chunithm.isEmpty)) {
                            Text("暂无数据")
                                .padding()
                        } else {
                            RecentSpotlightView(user: user)
                        }
                    }
                    .padding([.horizontal, .bottom])
                }
                Group {
                    HStack {
                        Text("Rating分析")
                            .font(.system(size: 20))
                            .bold()
                        Spacer()
                        
                        NavigationLink {
                            RatingDetailView(user: user)
                        } label: {
                            Text("显示全部")
                                .font(.system(size: 18))
                        }
                        .disabled(user.currentMode == 0 ? user.chunithm.isEmpty : user.maimai.isEmpty)
                    }
                    .padding(.horizontal)
                    
                    ScrollView(.horizontal) {
                        if(user.currentMode == 1 && !user.maimai.isEmpty) {
                            RatingAnalysisView(user: user)
                        }
                    }
                    .padding()
                }
                Group {
                    HStack {
                        Text("好友动态")
                            .font(.system(size: 20))
                            .bold()
                        Spacer()
                        
                    }
                    .padding(.horizontal)
                    
                    VStack {
                        Text("敬请期待")
                            .padding(.top)
                    }
                    .padding([.horizontal, .bottom])
                }
            }
        }
        .navigationTitle("主页")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    SettingsView(user: user)
                } label: {
                    Image(systemName: "gear")
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    Task {
                        // TODO: Add refresh button
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
    }
}

struct HomeTopView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(currentTab: .constant(.home))
    }
}
