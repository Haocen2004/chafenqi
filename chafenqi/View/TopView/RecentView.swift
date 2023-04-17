//
//  RecentView.swift
//  chafenqi
//
//  Created by 刘易斯 on 2023/2/18.
//

import SwiftUI

struct RecentView: View {
    @ObservedObject var user: CFQNUser
    
    var body: some View {
        VStack {
            if(user.didLogin) {
                if (user.currentMode == 0) {
                    if (!user.chunithm.isEmpty) {
                        VStack{
                            Text("暂无最近记录")
                                .padding()
                            Text("可通过传分器上传")
                        }
                    } else {
                        Form {
                            Section {
                                ForEach(user.chunithm.recentScore, id: \.playTime) { entry in
                                    NavigationLink {
                                        RecentDetailView(user: user, chuSong: entry.getSong(musicId: Int(entry.idx) ?? 0, songs: user.persistent.chunithm.songs), chuRecord: entry, mode: 0)
                                    } label: {
                                        RecentBasicView(user: user, chunithmSong: entry.getSong(musicId: Int(entry.idx) ?? 0, songs: user.persistent.chunithm.songs), chunithmRecord: entry, mode: 0)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    if (!user.maimai.isEmpty) {
                        VStack{
                            Text("暂无最近记录")
                                .padding()
                            Text("可通过传分器上传")
                        }
                    } else {
                        Form {
                            Section {
                                ForEach(user.maimai.recentScore, id: \.timestamp) { entry in
                                    NavigationLink {
                                        RecentDetailView(user: user, maiSong: entry.getSong(title: entry.title, songs: user.persistent.maimai.songs), maiRecord: entry, mode: 1)
                                    } label: {
                                        RecentBasicView(user: user, maimaiSong: entry.getSong(title: entry.title, songs: user.persistent.maimai.songs), maimaiRecord: entry, mode: 1)
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                Text("请先登录查分器账号！")
            }
        }
        .navigationTitle("最近动态")
        .navigationBarTitleDisplayMode(.inline)
    }
}

