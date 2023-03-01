//
//  FilterManager.swift
//  chafenqi
//
//  Created by 刘易斯 on 2023/3/2.
//

import Foundation

final class FilterManager: ObservableObject {
    static let chunithm = FilterManager()
    static let maimai = FilterManager()
    
    @Published var filter = false
    
    @Published var filterKeyword = ""
    
    @Published var filterTitle = false
    @Published var filterArtist = false
    @Published var filterPlayed = false
    
    @Published var filterConstant = false
    @Published var filterConstantLowerBound = ""
    @Published var filterConstantUpperBound = ""
    
    @Published var filterLevel = false
    @Published var filterLevelLowerBound = ""
    @Published var filterLevelUpperBound = ""
    
    @Published var filterGenre = false
    @Published var filterGenreSelection: Array<String> = []
    
    @Published var filterVersion = false
    @Published var filterVersionSelection: Array<String> = []
    
    @Published var filterResult: Array<AnyObject> = []
}
