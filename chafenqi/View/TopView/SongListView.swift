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
    
    @State private var showingDetail = false
    @State private var showingFilterPanel = false
    @State private var showingPlayed = false
    
    @State private var shouldFilter = false
    
    var body: some View {
        VStack{
            let isLoaded = mode == 0 ? didChunithmLoaded : didMaimaiLoaded
            
            if (isLoaded) {
                if (mode == 0) {
                    if filteredChunithmResults != nil {
                        List {
                            ForEach(filteredChunithmResults!.sorted(by: <), id: \.musicId) { song in
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
                    if filteredMaimaiResults != nil {
                        List {
                            ForEach(filteredMaimaiResults!.sorted(by: <), id: \.musicId) { song in
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
                    FilterPanelView(isOpen: $showingFilterPanel, shouldFilter: $shouldFilter, filter: mode == 0 ? chuFilter : maiFilter)
                }
//                Menu {
//                    Toggle(isOn: $showingPlayed) {
//                        Image(systemName: "rectangle.on.rectangle")
//                        Text("仅显示已游玩曲目")
//                    }
//                    .disabled(!didLogin)
//                } label: {
//                    Image(systemName: "line.3.horizontal.decrease.circle")
//                }
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
    
    var filteredMaimaiResults: Array<MaimaiSongData>? {
        guard didMaimaiLoaded && mode == 1 else { return nil }
        
        do {
            let songs = try decodedMaimaiSongs.isEmpty ? JSONDecoder().decode(Array<MaimaiSongData>.self, from: loadedMaimaiSongs) :
            decodedMaimaiSongs
            
            if (shouldFilter) {
                shouldFilter.toggle()
            }
            
            return songs
        } catch {
            return nil
        }
    }
    
    var filteredChunithmResults: Array<ChunithmSongData>? {
        guard didChunithmLoaded && mode == 0 else { return nil }
        
        do {
            var songs = try decodedChunithmSongs.isEmpty ? JSONDecoder().decode(Array<ChunithmSongData>.self, from: loadedChunithmSongs) :
            decodedChunithmSongs
            
            if (shouldFilter) {
                if (chuFilter.filterTitle && chuFilter.filterArtist) {
                    songs = songs.filterTitleAndArtist(keyword: chuFilter.filterKeyword)
                } else if (chuFilter.filterTitle) {
                    songs = songs.filterTitle(keyword: chuFilter.filterKeyword)
                } else if (chuFilter.filterArtist) {
                    songs = songs.filterArtist(keyword: chuFilter.filterKeyword)
                }
                
                if (chuFilter.filterConstant) {
                    // TODO: Add ablilty to change level index
                    songs = songs.filterConstant(levelIndex: 3, lower: Double(chuFilter.filterConstantLowerBound) ?? 0.0, upper: Double(chuFilter.filterConstantUpperBound) ?? 15.4)
                }
                
                if (chuFilter.filterLevel) {
                    songs = songs.filterLevel(lower: chuFilter.filterLevelLowerBound , upper: chuFilter.filterLevelUpperBound)
                }
                
                if (chuFilter.filterGenre) {
                    songs = songs.filterGenre(keywords: chuFilter.filterGenreSelection)
                }
                
                if (chuFilter.filterVersion) {
                    songs = songs.filterVersion(keywords: chuFilter.filterVersionSelection)
                }
                
                shouldFilter.toggle()
            }
            
            return songs
        } catch {
            return nil
        }
    }
}

struct MaimaiListView_Previews: PreviewProvider {
    static var previews: some View {
        SongListView()
    }
}
