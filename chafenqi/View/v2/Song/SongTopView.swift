//
//  SongTopView.swift
//  chafenqi
//
//  Created by 刘易斯 on 2023/5/8.
//

import SwiftUI
import SwiftlySearch

struct SongTopView: View {
    @ObservedObject var user: CFQNUser
    
    @State var filters = CFQFilterOptions()
    
    @State var filteredMaiSongs: [MaimaiSongData] = []
    @State var filteredChuSongs: [ChunithmSongData] = []
    @State var searchText = ""
    
    var body: some View {
        VStack {
            if #available(iOS 15.0, *) {
                List {
                    if (user.currentMode == 0) {
                        ForEach(filteredChuSongs, id: \.musicId) { entry in
                            SongItemView(user: user, chuSong: entry)
                        }
                    } else {
                        ForEach(filteredMaiSongs, id: \.musicId) { entry in
                            SongItemView(user: user, maiSong: entry)
                        }
                    }
                }
                .searchable(text: $searchText, prompt: Text("搜索标题/曲师"))
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .onSubmit(of: .search) {
                    filterSongs()
                }
                .onChange(of: searchText) { _ in
                    filterSongs()
                }
                .onAppear {
                    filterSongs()
                }
            } else {
                // Fallback on earlier versions
                List {
                    if (user.currentMode == 0) {
                        ForEach(filteredChuSongs, id: \.musicId) { entry in
                            SongItemView(user: user, chuSong: entry)
                        }
                    } else {
                        ForEach(filteredMaiSongs, id: \.musicId) { entry in
                            SongItemView(user: user, maiSong: entry)
                        }
                    }
                }
                .navigationBarSearch($searchText)
                .onChange(of: searchText) { _ in
                    filterSongs()
                }
                .onAppear {
                    filterSongs()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    SongFilterOptionsView(filters: $filters)
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
            }
        }
        .navigationTitle("歌曲列表")
    }
    
    func filterSongs() {
        if (user.currentMode == 0) {
            if (searchText.isEmpty) {
                filteredChuSongs = user.data.chunithm.songs
            } else {
                filteredChuSongs = user.data.chunithm.songs.filter {
                    $0.title.localizedCaseInsensitiveContains(searchText) ||
                    $0.basicInfo.artist.localizedCaseInsensitiveContains(searchText)
                }
            }
            
            let levelIndices = filters.filterChuLevelToggles.trueIndices
            let genreIndices = filters.filterChuGenreToggles.trueIndices
            if !levelIndices.isEmpty {
                filteredChuSongs = filteredChuSongs.filter { song in
                    let levels = levelIndices.compactMap { CFQFilterOptions.levelOptions[$0] }
                    return anyCommonElements(lhs: levels, rhs: song.level)
                }
            }
            if !genreIndices.isEmpty {
                filteredChuSongs = filteredChuSongs.filter { song in
                    let genres = genreIndices.compactMap { CFQFilterOptions.chuGenreOptions[$0] }
                    return genres.contains(song.basicInfo.genre)
                }
            }
        } else {
            if (searchText.isEmpty) {
                filteredMaiSongs = user.data.maimai.songlist
            } else {
                filteredMaiSongs = user.data.maimai.songlist.filter {
                    $0.title.localizedCaseInsensitiveContains(searchText) ||
                    $0.basicInfo.artist.localizedCaseInsensitiveContains(searchText)
                }
            }
            
            let levelIndices = filters.filterMaiLevelToggles.trueIndices
            let genreIndices = filters.filterMaiGenreToggles.trueIndices
            if !levelIndices.isEmpty {
                filteredMaiSongs = filteredMaiSongs.filter { song in
                    let levels = levelIndices.compactMap { CFQFilterOptions.levelOptions[$0] }
                    return anyCommonElements(lhs: levels, rhs: song.level)
                }
            }
            if !genreIndices.isEmpty {
                filteredMaiSongs = filteredMaiSongs.filter { song in
                    let genres = genreIndices.compactMap { CFQFilterOptions.maiGenreList[$0] }
                    return genres.contains(song.basicInfo.genre)
                }
            }
        }
    }
    
    func anyCommonElements <T, U> (lhs: T, rhs: U) -> Bool where T: Sequence, U: Sequence, T.Iterator.Element: Equatable, T.Iterator.Element == U.Iterator.Element {
        for lhsItem in lhs {
            for rhsItem in rhs {
                if lhsItem == rhsItem {
                    return true
                }
            }
        }
        return false
    }
}

struct SongTopView_Previews: PreviewProvider {
    static var previews: some View {
        SongTopView(user: CFQNUser())
    }
}
