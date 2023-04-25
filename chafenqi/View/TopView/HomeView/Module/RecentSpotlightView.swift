//
//  RecentSpotlightCardView.swift
//  chafenqi
//
//  Created by 刘易斯 on 2023/3/10.
//

import SwiftUI

struct RecentSpotlightView: View {    
    @ObservedObject var user = CFQNUser()
    
    let prompt = ["最近一首", "新纪录", "高分"]
    
    var body: some View {
        VStack {
            if (user.currentMode == 0) {
                if (!user.chunithm.isEmpty) {
                    let recents = [(0, user.chunithm.recentScore.first), user.chunithm.recentScore.getLatestNewRecord(), user.chunithm.recentScore.getLatestHighscore()]
                    ForEach(Array(recents.enumerated()), id: \.offset) { index, record in
                        let (_, entry) = record
                        if let entry = entry {
                            let song = entry.getSong(musicId: Int(entry.idx)!, songs: user.persistent.chunithm.songs)
                            NavigationLink {
                                RecentDetailView(user: user, chuSong: song, chuRecord: entry, mode: 0)
                            } label: {
                                HStack {
                                    SongCoverView(coverURL: ChunithmDataGrabber.getSongCoverUrl(source: user.chunithmCoverSource, musicId: entry.idx), size: 65, cornerRadius: 5)
                                        .padding(.trailing, 5)
                                    Spacer()
                                    VStack {
                                        HStack {
                                            Text(entry.getDateString())
                                            Spacer()
                                            Text(prompt[index])
                                                .bold()
                                        }
                                        Spacer()
                                        HStack(alignment: .bottom) {
                                            Text(entry.title)
                                                .font(.system(size: 17))
                                            Spacer()
                                            Text("\(entry.highscore)")
                                                .font(.system(size: 21))
                                                .bold()
                                        }
                                    }
                                }
                                .frame(height: 75)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            } else {
                if (!user.maimai.isEmpty) {
                    let recents = [(0, user.maimai.recentScore.first), user.maimai.recentScore.getLatestNewRecord(), user.maimai.recentScore.getLatestHighscore()]
                    ForEach(Array(recents.enumerated()), id: \.offset) { index, record in
                        let (_, entry) = record
                        if let entry = entry {
                            let song = entry.getSong(title: entry.title, songs: user.persistent.maimai.songs)
                            NavigationLink {
                                RecentDetailView(user: user, maiSong: song, maiRecord: entry, mode: 1)
                            } label: {
                                HStack {
                                    SongCoverView(coverURL: MaimaiDataGrabber.getSongCoverUrl(source: user.maimaiCoverSource, coverId: getCoverNumber(id: song.musicId)), size: 65, cornerRadius: 5)
                                        .padding(.trailing, 5)
                                    Spacer()
                                    VStack {
                                        HStack {
                                            Text(entry.getDateString())
                                            Spacer()
                                            Text(prompt[index])
                                                .bold()
                                        }
                                        Spacer()
                                        HStack(alignment: .bottom) {
                                            Text(entry.title)
                                                .font(.system(size: 17))
                                            Spacer()
                                            Text("\(entry.achievements)")
                                                .font(.system(size: 21))
                                                .bold()
                                        }
                                    }
                                }
                                .frame(height: 75)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }
}

struct RecentSpotlightCardView_Previews: PreviewProvider {
    static var previews: some View {
        RecentSpotlightView()
    }
}

