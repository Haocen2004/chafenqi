//
//  NamePlateView.swift
//  chafenqi
//
//  Created by 刘易斯 on 2023/3/10.
//

import SwiftUI

struct NamePlateView: View {
    @ObservedObject var user: CFQNUser
    
    @State private var nameplateChuniColorTop = Color(red: 254, green: 241, blue: 65)
    @State private var nameplateChuniColorBottom = Color(red: 243, green: 200, blue: 48)
    
    @State private var nameplateMaiColorTop = Color(red: 167, green: 243, blue: 254)
    @State private var nameplateMaiColorBottom = Color(red: 93, green: 166, blue: 247)
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(LinearGradient(colors: user.currentMode == 0 ? [nameplateChuniColorTop, nameplateChuniColorBottom] : [nameplateMaiColorTop, nameplateMaiColorBottom], startPoint: .top, endPoint: .bottom))
                    .shadow(radius: 5)
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        if(user.currentMode == 0) {
                            Image("nameplate_penguin")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .padding(.trailing, 10)
                                .frame(width: 110, height: 110)
                                .contextMenu {
                                    Button {
                                        // TODO: Add custom avatar
                                    } label: {
                                        Image(systemName: "rectangle.on.rectangle.angled")
                                        Text("照片图库")
                                    }
                                }
                            
                        } else {
                            Image("nameplate_salt")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .padding(.trailing, 10)
                                .frame(width: 110, height: 110)
                                .contextMenu {
                                    Button {
                                        // TODO: Add custom avatar
                                    } label: {
                                        Image(systemName: "rectangle.on.rectangle.angled")
                                        Text("照片图库")
                                    }
                                }
                        }
                    }
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(user.currentMode == 0 ? user.chunithm.info.nickname : user.maimai.info.nickname)
                                .foregroundColor(.black)
                                .font(.system(size: 25))
                                .bold()
                                .frame(maxWidth: 150, alignment: .leading)
                            
                            Spacer()
                            
                            Button {
                                withAnimation(.easeInOut(duration: 0.15)) {
                                    user.currentMode.flip()
                                }
                            } label: {
                                HStack {
                                    Text("切换游戏")
                                        .font(.system(size: 16))
                                    Image(systemName: "arrow.left.arrow.right")
                                }
                            }
                        }
                        .padding(.bottom, 5)
                        
                        Group {
                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text("Rating")
                                    if (user.currentMode == 0) {
                                        Text("\(user.chunithm.info.rating, specifier: "%.2f") (\(user.chunithm.info.maxRating, specifier: "%.2f"))")
                                            .bold()
                                    } else {
                                        Text(verbatim: "\(user.maimai.shim.rawRating)")
                                            .bold()
                                    }
                                }
                                
                                HStack {
                                    Group {
                                        if (user.currentMode == 0) {
                                            Group {
                                                Text("B")
                                                Text("\(user.chunithm.fishUserInfo.getAvgB30(), specifier: "%.2f")")
                                                    .bold()
                                                Text("/")
                                                Text("R")
                                                Text("\(user.chunithm.fishUserInfo.getAvgR10(), specifier: "%.2f")")
                                                    .bold()
                                            }
                                        } else {
                                            Group {
                                                Text("P")
                                                Text(verbatim: "\(user.maimai.shim.pastRating)")
                                                    .bold()
                                                Text("/")
                                                Text("N")
                                                Text(verbatim: "\(user.maimai.shim.currentRating)")
                                                    .bold()
                                            }
                                        }
                                    }
                                    
                                }
                                
                                HStack {
                                    if (user.currentMode == 0) {
                                        Text("OVERPOWER")
                                        
                                        Text("\(user.chunithm.info.overpower_raw, specifier: "%.2f")")
                                            .bold()
                                    } else {
                                        
                                        Text("排名")
                                        
                                        // TODO: Fix ranking
                                        Text("#0")
                                            .bold()
                                    }
                                }
                                
                                Spacer()
                                
                                HStack {
                                    if (user.currentMode == 0) {
                                        Text("更新于")
                                        Text(user.chunithm.info.updatedAt)
                                    } else {
                                        Text("更新于")
                                        Text(user.maimai.info.updatedAt)
                                    }
                                }
                            }
                        }
                        .foregroundColor(.black)
                        .font(.system(size: 16))
                    }
                    Spacer()
                }
                .padding()
            }
        }
        .padding()
    }
    
    var gradient: LinearGradient {
        if (user.currentMode == 0) {
            return LinearGradient(colors: [nameplateChuniColorTop, nameplateChuniColorBottom], startPoint: .top, endPoint: .bottom)
        } else {
            return LinearGradient(colors: [nameplateMaiColorTop, nameplateMaiColorBottom], startPoint: .top, endPoint: .bottom)
        }
    }
    
    var avatarName: String {
        if (user.currentMode == 0) {
            return "nameplate_penguin"
        } else {
            return "nameplate_salt"
        }
    }
}
