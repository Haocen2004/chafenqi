//
//  FilterPanelView.swift
//  chafenqi
//
//  Created by 刘易斯 on 2023/2/1.
//

import SwiftUI

struct FilterPanelView: View {
    @Binding var isOpen: Bool
    @Binding var shouldFilter: Bool
    
    @AppStorage("settingsCurrentMode") var mode = 0
    
    @ObservedObject var filter: FilterManager
    
    @State private var searchTitle = false
    @State private var searchArtist = false
    
    @State private var filterPlayedOnly = false
    
    @State private var filterConstant = false
    @State private var filterConstantUpperBound = ""
    @State private var filterConstantLowerBound = ""
    
    @State private var filterLevel = false
    @State private var filterLevelUpperBound = "1"
    @State private var filterLevelLowerBound = "15"
    
    @State private var filterGenre = true
    @State private var filterGenreOptions = ["POPS&ANIME", "niconico", "東方Project", "VARIETY", "イロドリミドリ", "ゲキマイ", "ORIGINAL"]
    @State private var filterGenreSelection = ["POPS&ANIME"]
    
    @State private var filterVersion = true
    @State private var filterVersionOptions = ["CHUNITHM", "CHUNITHM PLUS", "CHUNITHM AIR", "CHUNITHM AIR PLUS", "CHUNITHM STAR", "CHUNITHM STAR PLUS", "CHUNITHM AMAZON", "CHUNITHM AMAZON PLUS", "CHUNITHM CRYSTAL", "CHUNITHM CRYSTAL PLUS", "CHUNITHM PARADISE", "CHUNITHM PARADISE LOST", "CHUNITHM NEW!!"]
    @State private var filterVersionSelection = ["CHUNITHM NEW!!"]
    
    @State private var sortOptions = ["按等级", "按定数", "按版本", "按标题"]
    @State private var sortWays = ["升序", "降序"]
    @State private var sortBy = ""
    @State private var sortIn = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("关键词", text: $filter.filterKeyword)
                        .autocapitalization(UITextAutocapitalizationType.none)
                        .disableAutocorrection(true)
                    
                    Toggle(isOn: $filter.filterTitle) {
                        Text("搜索标题")
                    }
                    .disabled(filter.filterKeyword.isEmpty)
                    
                    Toggle(isOn: $filter.filterArtist) {
                        Text("搜索作者")
                    }
                    .disabled(filter.filterKeyword.isEmpty)
                } header: {
                    Text("搜索")
                }
                
                Section {
                    Toggle(isOn: $filter.filterPlayed) {
                        Text("仅显示已游玩曲目")
                    }
                    Toggle(isOn: $filter.filterConstant.animation(.easeInOut(duration: 0.3))) {
                        Text("筛选定数")
                    }
                    if (filter.filterConstant) {
                        HStack {
                            Text("定数范围")
                            Spacer()
                            TextField("0.0", text: $filter.filterConstantLowerBound)
                                .frame(width: 35)
                            Text("到")
                            TextField("0.0", text: $filter.filterConstantUpperBound)
                                .frame(width: 35)
                        }
                        
                    }
                    Toggle(isOn: $filter.filterLevel.animation(.easeInOut(duration: 0.3))) {
                        Text("筛选等级")
                    }
                    if (filter.filterLevel) {
                        HStack {
                            Text("等级范围")
                            Spacer()
                            Picker("", selection: $filter.filterLevelLowerBound) {
                                ForEach(1..<7) { text in
                                    Text(String(text))
                                }
                                ForEach(8..<15) { text in
                                    Text(String(text))
                                    Text("\(text)+")
                                }
                                Text("15")
                            }
                            .pickerStyle(.menu)
                            Text("到")
                            Picker("", selection: $filter.filterLevelUpperBound) {
                                ForEach(1..<7) { text in
                                    Text(String(text))
                                }
                                ForEach(8..<15) { text in
                                    Text(String(text))
                                    Text("\(text)+")
                                }
                                Text("15")
                            }
                            .pickerStyle(.menu)
                        }
                        
                    }
                    
                    NavigationLink {
                        FilterGenreView(genreOptions: filterGenreOptions, filter: filter)
                    } label: {
                        Text("筛选分类")
                        Spacer()
                        if (filter.filterGenre) {
                            Text("已选择\(filter.filterGenreSelection.count)项")
                                .foregroundColor(.gray)
                        } else {
                            Text("关闭")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    NavigationLink {
                        FilterVersionView(versionOptions: filterVersionOptions, filter: filter)
                    } label: {
                        Text("筛选版本")
                        Spacer()
                        if (filter.filterVersion) {
                            Text("已选择\(filter.filterVersionSelection.count)项")
                                .foregroundColor(.gray)
                        } else {
                            Text("关闭")
                                .foregroundColor(.gray)
                        }
                    }
                } header: {
                    Text("筛选")
                }
                
                Section {
                    Picker("", selection: $sortBy) {
                        
                    }
                } header: {
                    Text("排序")
                }
                
                Button {
                    
                } label: {
                    Text("重置筛选条件")
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("筛选和排序")
            .toolbar {
                ToolbarItem {
                    Button {
                        shouldFilter.toggle()
                        isOpen.toggle()
                    } label: {
                        Text("应用")
                    }
                }
            }
        }
    }
}

struct FilterPanelView_Previews: PreviewProvider {
    static var previews: some View {
        FilterPanelView(isOpen: .constant(true), shouldFilter: .constant(false), filter: FilterManager.chunithm)
    }
}

struct FilterVersionView: View {
    let versionOptions: Array<String>
    
    @ObservedObject var filter: FilterManager
    
    var body: some View {
        Form {
            ForEach(versionOptions, id: \.self) { option in
                HStack {
                    Text(option)
                    Spacer()
                    if (filter.filterVersionSelection.contains(option)) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.accentColor)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if (filter.filterVersionSelection.contains(option)) {
                        filter.filterVersionSelection.removeAll {
                            $0 == option
                        }
                    } else {
                        filter.filterVersionSelection.append(option)
                    }
                    
                    if (filter.filterVersionSelection.isEmpty) {
                        filter.filterVersion = false
                    } else {
                        filter.filterVersion = true
                    }
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FilterGenreView: View {
    let genreOptions: Array<String>
    
    @ObservedObject var filter: FilterManager
    
    var body: some View {
        Form {
            ForEach(genreOptions, id: \.self) { option in
                HStack {
                    Text(option)
                    Spacer()
                    if (filter.filterGenreSelection.contains(option)) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.accentColor)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if (filter.filterGenreSelection.contains(option)) {
                        filter.filterGenreSelection.removeAll {
                            $0 == option
                        }
                    } else {
                        filter.filterGenreSelection.append(option)
                    }
                    
                    if (filter.filterGenreSelection.isEmpty) {
                        filter.filterGenre = false
                    } else {
                        filter.filterGenre = true
                    }
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
