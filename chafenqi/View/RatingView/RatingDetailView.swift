//
//  RatingDetailView.swift
//  chafenqi
//
//  Created by 刘易斯 on 2023/3/19.
//

import SwiftUI

struct RatingDetailView: View {
    @ObservedObject var user: CFQNUser
    
    var body: some View {
        ScrollView {
            if (user.currentMode == 0) {
                if (!user.chunithm.isEmpty) {
                    RatingDetailChunithmView(mode: user.chunithmCoverSource, chunithm: user.chunithm)
                        .padding()
                }
            } else {
                if (!user.maimai.isEmpty) {
                    RatingDetailMaimaiView(mode: user.maimaiCoverSource, user: user)
                        .padding()
                }
            }
        }
        .onAppear {
            // Debug only
            // user.currentMode = 0
        }
        .navigationTitle("Rating详情")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RatingDetailMaimaiView: View {
    @State var mode: Int
    @State var user: CFQNUser
    
    @State var pastFold = false
    @State var newFold = false
    
    var body: some View {
        VStack {
            HStack {
                Text(verbatim: "\(user.maimai.shim.rawRating)")
                    .font(.system(size: 30))
                    .bold()
                Spacer()
                Text(verbatim: "Past \(user.maimai.shim.pastRating) / New \(user.maimai.shim.currentRating)")
            }
            .padding(.bottom)
            
            HStack {
                Text("旧曲 B25")
                    .font(.system(size: 20))
                    .bold()
                Spacer()
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        pastFold.toggle()
                    }
                } label: {
                    Text(pastFold ? "展开" : "收起")
                }
            }
            .padding(.bottom)
            
            if (!pastFold) {
                VStack(spacing: 15) {
                    ForEach(Array(user.maimai.shim.pastSlice.enumerated()), id: \.offset) { index, entry in
                        RatingMaimaiEntryBanner(mode: mode, index: index + 1, entry: entry, songs: user.persistent.maimai.songs)
                    }
                }
            }
            
            HStack {
                Text("新曲 B15")
                    .font(.system(size: 20))
                    .bold()
                Spacer()
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        newFold.toggle()
                    }
                } label: {
                    Text(newFold ? "展开" : "收起")
                }
            }
            .padding(.bottom)
            
            if (!newFold) {
                VStack(spacing: 15) {
                    ForEach(Array(user.maimai.shim.currentSlice.enumerated()), id: \.offset) { index, entry in
                        RatingMaimaiEntryBanner(mode: mode, index: index + 1, entry: entry, songs: user.persistent.maimai.songs)
                    }
                }
            }
        }
    }
}

struct RatingDetailChunithmView: View {
    @State var mode: Int
    @State var user: CFQNUser
    
    @State var bestFold = false
    @State var recentFold = false
    
    var body: some View {
        let chunithm = user.chunithm
        VStack {
            HStack(alignment: .bottom) {
                Text("\(chunithm.profile.getRating(), specifier: "%.2f")")
                    .font(.system(size: 30))
                    .bold()
                Spacer()
                Text("Best \(chunithm.profile.getAvgB30(), specifier: "%.2f") / Recent \(chunithm.profile.getAvgR10(), specifier: "%.2f")")
                    .font(.system(size: 20))
            }
            .padding(.bottom)
            
            HStack {
                Text("最佳成绩 B30")
                    .font(.system(size: 20))
                    .bold()
                Spacer()
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        bestFold.toggle()
                    }
                } label: {
                    Text(bestFold ? "展开" : "收起")
                }
            }
            .padding(.bottom)
            
            if(!bestFold) {
                VStack(spacing: 15) {
                    ForEach(Array(chunithm.rating.enumerated()), id: \.offset) { index, entry in
                        RatingChunithmEntryBanner(mode: mode, index: index + 1, entry: entry, bests: chunithm.bestScore, songs: user.persistent.chunithm.songs)
                    }
                }
            }
            
            HStack {
                Text("最近成绩 R10")
                    .font(.system(size: 20))
                    .bold()
                Spacer()
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        recentFold.toggle()
                    }
                } label: {
                    Text(recentFold ? "展开" : "收起")
                }
            }
            .padding(.bottom)
            
            if(!recentFold) {
                VStack(spacing: 15) {
                    ForEach(Array(chunithm.rating.enumerated()), id: \.offset) { index, entry in
                        RatingChunithmEntryBanner(mode: mode, index: index + 1, entry: entry, bests: chunithm.bestScore, songs: user.persistent.chunithm.songs)
                    }
                }
            }
        }
    }
}

struct RatingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RatingDetailView(user: CFQNUser())
    }
}

struct RatingChunithmEntryBanner: View {
    @State var mode: Int
    @State var index: Int
    @State var entry: CFQData.Chunithm.RatingEntry
    @State var bests: ChunithmBestScoreEntries
    @State var songs: Array<ChunithmSongData>
    
    var body: some View {
        let song = entry.getSong(bests: bests)
        let data = song.getSong(musicId: Int(song.idx)!, songs: songs)
        HStack {
            SongCoverView(coverURL: ChunithmDataGrabber.getSongCoverUrl(source: mode, musicId: entry.idx), size: 50, cornerRadius: 5)
                .padding(.trailing, 5)
            Group {
                VStack(alignment: .leading) {
                    HStack {
                        Text("#\(index)")
                            .frame(width: 35, alignment: .leading)
                        Text("\(data.constant[song.level_index], specifier: "%.1f")/\(song.getRating(songs: songs), specifier: "%.2f")")
                            .bold()
                            .frame(width: 90, alignment: .leading)
                    }
                    Spacer()
                    Text("\(entry.title)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    HStack {
                        let status = song.getStatus()
                        if (status != "Clear") {
                            Text("\(song.getStatus())")
                        }
                        GradeBadgeView(grade: song.getGrade(rankIndex: song.rank_index))
                    }
                    Spacer()
                    Text("\(entry.highscore)")
                    
                }
            }
            .font(.system(size: 18))
        }
        .frame(height: 50)
    }
}

struct RatingMaimaiEntryBanner: View {
    @State var mode: Int
    @State var index: Int
    @State var entry: CFQData.Maimai.BestScoreEntry
    @State var songs: Array<MaimaiSongData>
    
    var body: some View {
        HStack {
            SongCoverView(coverURL: MaimaiDataGrabber.getSongCoverUrl(source: mode, coverId: getCoverNumber(id: String(entry.getMusicId(songs: songs)))), size: 50, cornerRadius: 5)
                .padding(.trailing, 5)
            Group {
                VStack(alignment: .leading) {
                    HStack {
                        Text("#\(index)")
                            .frame(width: 35, alignment: .leading)
                        Text("\(entry.getConstant(songs: songs), specifier: "%.1f")/\(entry.getRating(songs: songs))")
                            .bold()
                            .frame(width: 90, alignment: .leading)
                    }
                    Spacer()
                    Text("\(entry.title)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    HStack {
                        Text("\(entry.getStatus())")
                        GradeBadgeView(grade: entry.rate)
                    }
                    Spacer()
                    Text("\(entry.achievements, specifier: "%.4f")%")
                    
                }
            }
            .font(.system(size: 18))
        }
        .frame(height: 50)
    }
}
