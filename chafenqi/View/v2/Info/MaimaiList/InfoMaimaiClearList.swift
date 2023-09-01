//
//  InfoMaimaiClearList.swift
//  chafenqi
//
//  Created by xinyue on 2023/6/21.
//

import SwiftUI

let clearListColors: [Color] = [maiRankHex[0], .pink, .green, .blue, .red, .purple, .gray]


struct InfoMaimaiClearList: View {
    @ObservedObject var user: CFQNUser
    
    @State private var isLoading = true
    @State private var currentLevel = 18
    @State private var currentRatio = [Double]()
    @State private var currentFold = [Bool]()
    @State private var info = CFQMaimaiLevelRecords()
    
    var body: some View {
        ScrollView {
            if !isLoading {
                HStack(alignment: .bottom) {
                    Text("等级")
                    Text("\(CFQMaimaiLevelRecords.maiLevelStrings[currentLevel])")
                        .bold()
                        .font(.system(size: 25))
                    Spacer()
                    Button {
                        if currentLevel > 0 {
                            withAnimation {
                                currentLevel -= 1
                                currentRatio = info.levels[currentLevel].ratios
                                currentFold = Array(repeating: false, count: info.levels[currentLevel].grades.count)
                            }
                        }
                    } label: {
                        Image(systemName: "minus")
                            .frame(width: 15, height: 15)
                    }
                    .padding(.trailing, 20)
                    .disabled(currentLevel <= 0)
                    Button {
                        if currentLevel < 22 {
                            withAnimation {
                                currentLevel += 1
                                currentRatio = info.levels[currentLevel].ratios
                                currentFold = Array(repeating: false, count: info.levels[currentLevel].grades.count)
                            }
                        }
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 15, height: 15)
                    }
                    .disabled(currentLevel >= 22)
                }
                .padding()
                
                MaimaiClearBarView(datas: $currentRatio)
                    .frame(height: 25)
                    .mask(RoundedRectangle(cornerRadius: 5))
                    .padding([.bottom, .horizontal])
                HStack {
                    ForEach(Array(maiRankDesc.enumerated()), id: \.offset) { index, string in
                        Circle()
                            .foregroundColor(clearListColors[index])
                            .frame(width: 8)
                        Text(string)
                    }
                }
                .padding(.bottom)
                
                let levelInfo = info.levels[currentLevel]
                LazyVStack {
                    ForEach(Array(maiRankDesc.enumerated()), id: \.offset) { index, rankString in
                        let gradeInfo = info.levels[currentLevel].grades[index]
                        if gradeInfo.count != 0 {
                            HStack {
                                Text(rankString)
                                    .bold()
                                Text("\(gradeInfo.count)/\(levelInfo.count)")
                                Spacer()
                                Button {
                                    withAnimation {
                                        currentFold[index].toggle()
                                    }
                                } label: {
                                    Text(currentFold[index] ? "展开" : "收起")
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 5)
                            if !currentFold[index] {
                                VStack {
                                    ForEach(gradeInfo.songs, id: \.idx) { song in
                                        MaimaiBestEntryBannerView(song: song)
                                            .padding(.horizontal)
                                    }
                                    //                                if !levelInfo.noRecordSongs.isEmpty && index == 6 {
                                    //                                    ForEach(levelInfo.noRecordSongs, id: \.musicId) { song in
                                    //                                        MaimaiBestEntryBannerView(data: song, levelIndex: currentLevel)
                                    //                                            .padding(.horizontal)
                                    //                                    }
                                    //                                }
                                }
                            }
                        }
                    }
                    .id(UUID())
                }
            }
        }
        .onAppear {
            isLoading = true
            info = user.maimai.custom.levelRecords
            withAnimation {
                currentRatio = info.levels[currentLevel].ratios
                currentFold = Array(repeating: false, count: info.levels[currentLevel].grades.count)
            }
            isLoading = false
        }
        .navigationTitle("歌曲完成度")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func setCurrentLevelIndex(to index: Int) {
        currentLevel = index
        let currenInfo = info.levels[currentLevel]
        currentRatio = currenInfo.ratios
        if !currenInfo.noRecordSongs.isEmpty {
            
        }
        currentFold = Array(repeating: false, count: info.levels[currentLevel].grades.count)
    }
}

struct MaimaiBestEntryBannerView: View {
    var song: CFQMaimai.BestScoreEntry?
    var data: MaimaiSongData?
    var levelIndex: Int?
    
    var body: some View {
        HStack {
            if let song = data {
                SongCoverView(coverURL: song.coverURL, size: 50, cornerRadius: 5)
                VStack(alignment: .leading) {
                    Text("\(constantByLevelIndex(from: song), specifier: "%.1f")")
                    Spacer()
                    HStack {
                        Text(song.title)
                            .lineLimit(1)
                        Spacer()
                        Text("暂未游玩")
                            .bold()
                    }
                }
            } else if let song = song {
                SongCoverView(coverURL: song.associatedSong!.coverURL, size: 50, cornerRadius: 5)
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(song.associatedSong!.constant[song.levelIndex], specifier: "%.1f")/\(song.rating)")
                        Spacer()
                        // Text(diff(of: song))
                    }
                    Spacer()
                    HStack {
                        Text(song.title)
                            .lineLimit(1)
                        Spacer()
                        Text("\(song.score, specifier: "%.4f")%")
                            .bold()
                    }
                }
            }
        }
    }
    
    func constantByLevelIndex(from song: MaimaiSongData) -> Double {
        let string = CFQMaimaiLevelRecords.maiLevelStrings[levelIndex ?? 0]
        let idx = song.level.firstIndex(of: string) ?? 0
        return song.constant[idx]
    }
    
    func diff(of entry: CFQMaimai.BestScoreEntry) -> String {
        let string = entry.level
        let idx = entry.associatedSong!.level.firstIndex(of: string) ?? 0
        return ["BASIC", "ADVANCED", "EXPERT", "MASTER", "Re:MASTER"][idx]
    }
}

struct MaimaiClearBarView: View {
    @Binding var datas: [Double]
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                ForEach(Array(datas.enumerated()), id: \.offset) { index, dataPoint in
                    Rectangle()
                        .foregroundColor(clearListColors[index])
                        .frame(width: geo.size.width * dataPoint)
                }
                Rectangle()
                    .foregroundColor(.gray)
            }
        }
    }
}

extension Shape {
    /// fills and strokes a shape
    public func fill<S:ShapeStyle>(
        _ fillContent: S,
        strokeContent: S,
        strokeStyle: StrokeStyle
    ) -> some View {
        ZStack {
            self.fill(fillContent)
            self.stroke(strokeContent, style: strokeStyle)
        }
    }
}
