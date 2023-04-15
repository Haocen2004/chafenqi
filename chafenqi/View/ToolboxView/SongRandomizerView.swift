//
//  SongRandomizerView.swift
//  chafenqi
//
//  Created by 刘易斯 on 2023/2/1.
//

import SwiftUI
import CachedAsyncImage

struct SongRandomizerView: View {
    @AppStorage("settingsRandomizerFilterMode") var filterMode = 0
    
    @ObservedObject var user: CFQNUser
    
    @State private var isSpinning = false
    @State private var showingConstant = false
    
    @State private var decodedMaimaiSongs: Array<MaimaiSongData> = []
    @State private var decodedChunithmSongs: Array<ChunithmSongData> = []
    
    @State private var randomChunithmSong = tempSongData
    @State private var randomMaimaiSong = tempMaimaiSong
    @State private var coverURL = URL(string: "https://raw.githubusercontent.com/Louiswu2011/Chunithm-Song-Cover/main/images/3.png")
    
    @State private var screenBounds = UIScreen.main.bounds
    @State var firstTimeAppear: Bool = true
    
    var body: some View {
        HStack {
            VStack(alignment: .center) {
                SongCoverView(coverURL: coverURL!, size: 200, cornerRadius: 5)
                
                Text(user.currentMode == 0 ? randomChunithmSong.basicInfo.title : randomMaimaiSong.basicInfo.title)
                    .bold()
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .padding([.top, .horizontal])
                
                
                Text(user.currentMode == 0 ? randomChunithmSong.basicInfo.artist : randomMaimaiSong.basicInfo.artist)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding([.bottom, .horizontal])
                
                HStack {
                    if (user.currentMode == 0) {
                        Text(showingConstant ? String(format: "%.1f", randomChunithmSong.constant[0]) : randomChunithmSong.level[0])
                            .foregroundColor(Color.green)
                            .font(.title3)
                        Text(showingConstant ? String(format: "%.1f", randomChunithmSong.constant[1]) : randomChunithmSong.level[1])
                            .foregroundColor(Color.yellow)
                            .font(.title3)
                        Text(showingConstant ? String(format: "%.1f", randomChunithmSong.constant[2]) : randomChunithmSong.level[2])
                            .foregroundColor(Color.red)
                            .font(.title3)
                        Text(showingConstant ? String(format: "%.1f", randomChunithmSong.constant[3]) : randomChunithmSong.level[3])
                            .foregroundColor(Color.purple)
                            .font(.title3)
                        if (randomChunithmSong.level.count == 5) {
                            Text(showingConstant ? String(format: "%.1f", randomChunithmSong.constant[4]) : randomChunithmSong.level[4])
                                .font(.title3)
                        }
                    } else {
                        Text(showingConstant ? String(format: "%.1f", randomMaimaiSong.constant[0]) : randomMaimaiSong.level[0])
                            .foregroundColor(Color.green)
                            .font(.title3)
                        Text(showingConstant ? String(format: "%.1f", randomMaimaiSong.constant[1]) : randomMaimaiSong.level[1])
                            .foregroundColor(Color.yellow)
                            .font(.title3)
                        Text(showingConstant ? String(format: "%.1f", randomMaimaiSong.constant[2]) : randomMaimaiSong.level[2])
                            .foregroundColor(Color.red)
                            .font(.title3)
                        Text(showingConstant ? String(format: "%.1f", randomMaimaiSong.constant[3]) : randomMaimaiSong.level[3])
                            .foregroundColor(Color.purple)
                            .font(.title3)
                        if (randomMaimaiSong.level.count == 5) {
                            Text(showingConstant ? String(format: "%.1f", randomMaimaiSong.constant[4]) : randomMaimaiSong.level[4])
                                .foregroundColor(Color.purple.opacity(0.33))
                                .font(.title3)
                        }
                    }
                }
                .onTapGesture {
                    showingConstant.toggle()
                }
                
                HStack {
                    Button {
                        if (user.currentMode == 0) {
                            randomChunithmSong = getChunithmRandomSong()
                        } else {
                            randomMaimaiSong = getMaimaiRandomSong()
                        }
                    } label: {
                        Text("再来一首")
                        Image(systemName: "dice")
                    }
                    // .disabled(isSpinning)
                    .padding(.horizontal)
                    
                    NavigationLink {
                        if (user.currentMode == 0) {
                            ChunithmDetailView(user: user, song: randomChunithmSong)
                        } else {
                            MaimaiDetailView(user: user, song: randomMaimaiSong)
                        }
                    } label: {
                        Text("转到详情")
                        Image(systemName: "arrowshape.turn.up.right")
                    }
                    // .disabled(isSpinning)
                    .padding(.horizontal)
                }
                .padding()
            }
        }
        .onAppear {
            if firstTimeAppear {
                initRandomView()
            }
        }
        .navigationTitle("随机歌曲")
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    func initRandomView() {
        if (user.currentMode == 0) {
            filterChunithmSongList()
            decodedChunithmSongs = user.persistent.chunithm.songs
            randomChunithmSong = getChunithmRandomSong()
        } else {
            filterMaimaiSongList()
            decodedMaimaiSongs = user.persistent.maimai.songs
            randomMaimaiSong = getMaimaiRandomSong()
        }
        firstTimeAppear = false
    }
    
    func filterChunithmSongList() {
        guard user.didLogin && !user.chunithm.isEmpty else { return }
        
        switch (filterMode) {
        case 0:
            return
        case 1:
            let playedList = user.chunithm.bestScore.compactMap { $0.idx }
            decodedChunithmSongs = decodedChunithmSongs.filter { !playedList.contains(String($0.musicId)) }
        default:
            let playedList = user.chunithm.bestScore.compactMap { $0.idx }
            decodedChunithmSongs = decodedChunithmSongs.filter { playedList.contains(String($0.musicId)) }
        }
    }
    
    func filterMaimaiSongList() {
        guard user.didLogin && !user.maimai.isEmpty else { return }
        
        switch (filterMode) {
        case 0:
            return
        case 1:
            let playedList = user.maimai.bestScore.compactMap{ $0.title }
            decodedMaimaiSongs = decodedMaimaiSongs.filter { !playedList.contains( $0.title) }
        default:
            let playedList = user.maimai.bestScore.compactMap{ $0.title }
            decodedMaimaiSongs = decodedMaimaiSongs.filter { !playedList.contains( $0.title) }
        }
    }
    
    func getChunithmRandomSong() -> ChunithmSongData {
        let randSong = decodedChunithmSongs.randomElement()!
        coverURL = ChunithmDataGrabber.getSongCoverUrl(source: user.chunithmCoverSource, musicId: String(randSong.musicId))
        return randSong
    }
    
    func getMaimaiRandomSong() -> MaimaiSongData {
        let randSong = decodedMaimaiSongs.randomElement()!
        coverURL = MaimaiDataGrabber.getSongCoverUrl(source: user.maimaiCoverSource, coverId: getCoverNumber(id: randSong.musicId))
        
        return randSong
    }
}

