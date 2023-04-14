//
//  AlertToastModel.swift
//  chafenqi
//
//  Created by 刘易斯 on 2023/4/15.
//

import Foundation
import AlertToast

class AlertToastModel: ObservableObject {
    @Published var show = false
    
    @Published var toast = AlertToast(displayMode: .hud, type: .error(.red), title: ""){
        didSet {
            show.toggle()
        }
    }
    
    static var shared = AlertToastModel()
}
