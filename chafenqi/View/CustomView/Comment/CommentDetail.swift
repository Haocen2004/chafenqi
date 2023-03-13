//
//  CommentDetail.swift
//  chafenqi
//
//  Created by 刘易斯 on 2023/3/13.
//

import SwiftUI

struct CommentDetail: View {
    @AppStorage("settingsCurrentMode") var mode = 0
    @AppStorage("didLogin") var didLogin = false
    
    @AppStorage("userAccountName") var accountName = ""
    
    @State var comments: Array<Comment> = []
    
    var body: some View {
        Form {
            ForEach(Array(comments.enumerated()), id: \.offset) { index, comment in
                VStack(alignment: .leading) {
                    HStack {
                        // TODO: Add Like/Dislike counter
                        Text(comment.nickname)
                            .font(.system(size: 15))
                            .bold()
                            .lineLimit(1)
                        Spacer()
                        
//                        HStack {
//                            Image(systemName: "hand.thumbsup")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 15)
//                            Text("\(comment.like)")
//                        }
//                        .onTapGesture {
//                            comments[index].addLike()
//                        }
//
//                        HStack {
//                            Image(systemName: "hand.thumbsdown")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 15)
//                            Text("\(comment.dislike)")
//                        }
                        
                        Text(comment.getDateString())
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical)
                    
                    Text(comment.message)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .padding(.bottom)
                }
                .contextMenu {
                    if (comment.sender != accountName) {
                        Button {
                            Task {
                                let result = await comment.postLike()
                                if (result) {
                                    // TODO: Add success toast
                                } else {
                                    // TODO: Add fail toast
                                }
                            }
                        } label: {
                            Image(systemName: "hand.thumbsup")
                            Text("赞")
                        }
                        
                        Button {
                            Task {
                                let result = await comment.postDislike()
                                if (result) {
                                    // TODO: Add success toast
                                } else {
                                    // TODO: Add fail toast
                                }
                            }
                        } label: {
                            Image(systemName: "hand.thumbsdown")
                            Text("踩")
                        }
                    }
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "arrowshape.turn.up.forward")
                        Text("回复")
                    }
                    
                    if (comment.sender == accountName) {
                        Button {
                            Task {
                                let result = await comment.delete()
                                if (result) {
                                    comments.remove(at: index)
                                    // TODO: Add success toast
                                } else {
                                    // TODO: Add fail toast
                                }
                            }
                        } label: {
                            Image(systemName: "trash")
                            Text("删除")
                        }
                    }
                }
            }
            .navigationTitle("评论")
            .navigationBarTitleDisplayMode(.inline)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .buttonStyle(.borderless)
    }
}

struct CommentDetail_Previews: PreviewProvider {
    static var previews: some View {
        CommentDetail(comments: [Comment.shared, Comment.shared, Comment.shared, Comment.shared, Comment.shared])
    }
}
