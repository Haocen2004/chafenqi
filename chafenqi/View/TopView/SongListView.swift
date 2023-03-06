//
//  MaimaiListView.swift
//  chafenqi
//
//  Created by 刘易斯 on 2023/2/3.
//

import SwiftUI

struct SongListView: View {
    @AppStorage("settingsCurrentMode") var mode = 0
    
    @AppStorage("settingsMaimaiCoverSource") var maimaiCoverSource = 0
    @AppStorage("settingsChunithmCoverSoruce") var chunithmCoverSource = 0
    
    @AppStorage("loadedMaimaiSongs") var loadedMaimaiSongs = Data()
    @AppStorage("loadedChunithmSongs") var loadedChunithmSongs = Data()
    
    @AppStorage("didLogin") var didLogin = false
    
    @AppStorage("userMaimaiInfoData") var userMaimaiInfoData = Data()
    @AppStorage("userChunithmInfoDta") var userChunithmInfoData = Data()
    
    @AppStorage("didMaimaiSongListLoaded") private var didMaimaiLoaded = false
    @AppStorage("didChunithmSongListLoaded") private var didChunithmLoaded = false
    
    @ObservedObject var maiFilter = FilterManager.maimai
    @ObservedObject var chuFilter = FilterManager.chunithm
    
    @State private var searchText = ""
    
    @State private var decodedMaimaiSongs: Array<MaimaiSongData> = []
    @State private var decodedChunithmSongs: Array<ChunithmSongData> = []
    
    @State private var filteredMaimaiResults: Array<MaimaiSongData>? = []
    @State private var filteredChunithmResults: Array<ChunithmSongData>? = []
    
    @State private var showingDetail = false
    @State private var showingFilterPanel = false
    @State private var showingPlayed = false
    
    @State private var shouldFilter = false
    
    var body: some View {
        VStack{
            let isLoaded = mode == 0 ? didChunithmLoaded : didMaimaiLoaded
            
            if (isLoaded) {
                if (mode == 0) {
                    if decodedChunithmSongs != nil {
                        List {
                            ForEach(decodedChunithmSongs.sorted(by: <), id: \.musicId) { song in
                                NavigationLink {
                                    ChunithmDetailView(song: song)
                                } label: {
                                    SongBasicView(chunithmSong: song)
                                }
                                
                            }
                        }
                    } else {
                        VStack(spacing: 15) {
                            ProgressView()
                            Text("加载歌曲列表中...")
                        }
                    }
                } else {
                    if decodedMaimaiSongs != nil {
                        List {
                            ForEach(decodedMaimaiSongs.sorted(by: <), id: \.musicId) { song in
                                NavigationLink {
                                    MaimaiDetailView(song: song)
                                } label: {
                                    SongBasicView(maimaiSong: song)
                                }
                                
                            }
                        }
                    } else {
                        VStack(spacing: 15) {
                            ProgressView()
                            Text("加载歌曲列表中...")
                        }
                    }
                }
            } else {
                VStack(spacing: 15) {
                    ProgressView()
                    Text("加载歌曲列表中...")
                }
            }
            
        }
        .navigationTitle("曲目列表")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingFilterPanel.toggle()
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
                .sheet(isPresented: $showingFilterPanel) {
                    FilterPanelView(isOpen: $showingFilterPanel, filteredMaimaiResult: decodedMaimaiSongs, filteredChunithmResult: decodedChunithmSongs, filter: mode == 0 ? chuFilter : maiFilter)
                }
            }
        }
        .onAppear {
            if (mode == 0) {
                if (loadedChunithmSongs.isEmpty) {
                    didChunithmLoaded = false
                    Task {
                        do {
                            try await loadedChunithmSongs = JSONEncoder().encode(ChunithmDataGrabber.getSongDataSetFromServer())
                            decodedChunithmSongs = try JSONDecoder().decode(Array<ChunithmSongData>.self, from: loadedChunithmSongs)
                            didChunithmLoaded = true
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                } else {
                    didChunithmLoaded = true
                }
            } else {
                if (loadedMaimaiSongs.isEmpty) {
                    didMaimaiLoaded = false
                    Task {
                        do {
                            try await loadedMaimaiSongs = JSONEncoder().encode(MaimaiDataGrabber.getMusicData())
                            decodedMaimaiSongs = try JSONDecoder().decode(Array<MaimaiSongData>.self, from: loadedMaimaiSongs)
                            didMaimaiLoaded = true
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                } else {
                    didMaimaiLoaded = true
                }
            }
        }
        .autocapitalization(.none)
        .autocorrectionDisabled(true)
        
    }
}

struct MaimaiListView_Previews: PreviewProvider {
    static var previews: some View {
        SongListView()
    }
}
