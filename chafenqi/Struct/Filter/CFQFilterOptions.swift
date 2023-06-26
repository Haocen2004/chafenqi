//
//  CFQFilterOptions.swift
//  chafenqi
//
//  Created by xinyue on 2023/5/29.
//

import Foundation

struct CFQFilterOptions {
    static let shared = CFQFilterOptions()
    
    static var levelOptions: [String] {
        var options: [String] = []
        for i in 1...15 {
            options.append("\(i)")
            if (7...14).contains(i) {
                options.append("\(i)+")
            }
        }
        return options
    }
    
    static let chuGenreOptions = ["ORIGINAL", "POPS & ANIME", "VARIETY", "niconico", "東方Project", "イロドリミドリ", "ゲキマイ"]
    static let maiGenreOptions = ["\u{821e}\u{840c}", "\u{6d41}\u{884c}&\u{52a8}\u{6f2b}", "\u{5176}\u{4ed6}\u{6e38}\u{620f}", "niconico & VOCALOID", "\u{4e1c}\u{65b9}Project", "\u{97f3}\u{51fb}&\u{4e2d}\u{4e8c}\u{8282}\u{594f}"]
    static let chuVersionOptions = [
        "CHUNITHM",
        "CHUNITHM PLUS",
        "CHUNITHM AIR",
        "CHUNITHM AIR PLUS",
        "CHUNITHM STAR",
        "CHUNITHM STAR PLUS",
        "CHUNITHM AMAZON",
        "CHUNITHM AMAZON PLUS",
        "CHUNITHM CRYSTAL",
        "CHUNITHM CRYSTAL PLUS",
        "CHUNITHM PARADISE",
        "CHUNITHM PARADISE LOST",
        "CHUNITHM NEW"
    ]
    static let maiVersionOptions = [
        "maimai",
        "maimai PLUS",
        "maimai GreeN",
        "maimai GreeN PLUS",
        "maimai ORANGE",
        "maimai ORANGE PLUS",
        "maimai PiNK",
        "maimai PiNK PLUS",
        "maimai MURASAKi",
        "maimai MURASAKi PLUS",
        "maimai MiLK",
        "maimai MiLK PLUS",
        "maimai FiNALE",
        "maimai \u{3067}\u{3089}\u{3063}\u{304f}\u{3059}",
        "maimai \u{3067}\u{3089}\u{3063}\u{304f}\u{3059} Splash",
        "maimai \u{3067}\u{3089}\u{3063}\u{304f}\u{3059} Splash PLUS",
        "maimai \u{3067}\u{3089}\u{3063}\u{304f}\u{3059} UNiVERSE",
        "maimai \u{3067}\u{3089}\u{3063}\u{304f}\u{3059} UNiVERSE PLUS",
        "maimai \u{3067}\u{3089}\u{3063}\u{304f}\u{3059} FESTiVAL"
    ]
    static let sortOptions = [
        "无",
        "等级",
        "定数",
        "BPM"
    ]
    static let sortMethods = [
        "升序",
        "降序"
    ]
    
    var filterMaiLevelToggles: [Bool] = []
    var filterMaiGenreToggles: [Bool] = []
    var filterMaiVersionToggles: [Bool] = []
    var sortMaiSelection: String = "无"
    
    var filterChuGenreToggles: [Bool] = []
    var filterChuLevelToggles: [Bool] = []
    var filterChuVersionToggles: [Bool] = []
    var sortChuSelection: String = "无"
    
    var excludeChuWEChart: Bool = true
}
