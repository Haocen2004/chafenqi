//
//  AlertToastManager.swift
//  chafenqi
//
//  Created by 刘易斯 on 2023/2/13.
//

import Foundation

final class AlertToastManager: ObservableObject {
    @Published var showingUpdaterPasted = false
    @Published var showingTutorialReseted = false
    @Published var showingRecordDeleted = false
    @Published var showingCommentPostSucceed = false
    @Published var showingCommentPostFailed = false
    
    // CFQServer Related
    @Published var showingUsernameNotUniqueToast = false
    @Published var showingCredentialsNotMatchToast = false
    @Published var showingRequestErrorToast = false
    @Published var showingParsingErrorToast = false
    
    static let shared = AlertToastManager()
}
