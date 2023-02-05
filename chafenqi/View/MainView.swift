//
//  ContentView.swift
//  chafenqi
//
//  Created by 刘易斯 on 2023/1/6.
//

import SwiftUI

let maimaiLevelColor = [
    0: Color(red: 128 / 255, green: 216 / 255, blue: 98 / 255),
    1: Color(red: 242 / 255, green: 218 / 255, blue: 71 / 255),
    2: Color(red: 237 / 255, green: 127 / 255, blue: 132 / 255),
    3: Color(red: 176 / 255, green: 122 / 255, blue: 238 / 255),
    4: Color(red: 206 / 255, green: 164 / 255, blue: 251 / 255)
]

let chunithmLevelColor = [
    0: Color(red: 73 / 255, green: 166 / 255, blue: 137 / 255),
    1: Color(red: 237 / 255, green: 123 / 255, blue: 33 / 255),
    2: Color(red: 205 / 255, green: 85 / 255, blue: 77 / 255),
    3: Color(red: 171 / 255, green: 104 / 255, blue: 249 / 255),
    4: Color(red: 32 / 255, green: 32 / 255, blue: 32 / 255)
]

struct MainView: View {
    @AppStorage("favList") var favList = "0;"
    @AppStorage("settingsCurrentMode") var mode = 0 // 0: Chunithm NEW, 1: maimaiDX
    
    @State private var searchText = ""
    @State private var searchSeletedItem = ""
    @State private var showingLoginView = false
    
    var body: some View {
        TabView {
            NavigationView {
                if (mode == 0) {
                    ChunithmHomeView()
                } else {
                    MaimaiHomeView()
                }
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("主页")
            }
            
            NavigationView {
                if (mode == 0) {
                    ChunithmListView()
                } else {
                    MaimaiListView()
                }
            }
            .tabItem {
                Image(systemName: "music.note.list")
                Text("歌曲")
            }
            
            NavigationView {
                ToolView()
            }
            .tabItem {
                Image(systemName: "shippingbox.fill")
                Text("工具")
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
