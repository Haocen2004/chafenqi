//
//  RecentDetailView.swift
//  chafenqi
//
//  Created by 刘易斯 on 2023/2/19.
//

import SwiftUI

struct RecentDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("settingsMaimaiCoverSource") var maimaiCoverSource = 0
    @AppStorage("settingsChunithmCoverSoruce") var chunithmCoverSource = 0
    
    var chuSong: ChunithmSongData? = tempSongData
    var maiSong: MaimaiSongData? = tempMaimaiSong
    
    var chuRecord = ChunithmRecentRecord.shared
    var maiRecord = MaimaiRecentRecord.shared
    
    var mode = 0
    
    @State var requestURL = ""
    
    @State var title = ""
    @State var artist = ""
    @State var playTime = ""
    @State var difficulty = ""
    @State var diffColor = Color.black
    @State var score = ""
    
    @State var chuniJudgeWidth = CGFloat(160)
    @State var chuniMaxCombo = 0
    @State var chuniWidthArray: Array<CGFloat> = []
    
    @State var isLoaded = false
    
    var body: some View {
        ScrollView {
            if (isLoaded) {
                VStack {
                    HStack {
                        SongCoverView(coverURL: URL(string: requestURL)!, size: 120, cornerRadius: 10, withShadow: false)
                        
                        VStack(alignment: .leading) {
                            Spacer()
                            Text(title)
                                .font(.title)
                                .bold()
                                .lineLimit(2)
                                .minimumScaleFactor(0.8)
                            Text(artist)
                                .font(.title2)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        }
                        
                        Spacer()
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(diffColor.opacity(0.7))
                        
                        Text(playTime)
                            .padding(3)
                    }
                    .padding(.bottom,5)
                    
                    if (mode == 0) {
                        HStack(alignment: .bottom) {
                            Text(chuRecord.score)
                                .font(.system(size: 30))
                                .bold()
                            
                            Text(chuRecord.getGrade())
                                .font(.system(size: 20))
                            
                            Text(chuRecord.fc_status.uppercased())
                                .font(.system(size: 20))
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                        
                        HStack {
                            VStack {
                                ZStack(alignment: .trailing) {
                                    Rectangle()
                                        .fill(Color.yellow.opacity(0.6))
                                        .frame(width: chuniWidthArray[0])
                                    
                                    HStack {
                                        VStack{
                                            Text("Justice")
                                            Text("Critical")
                                                .font(.system(size: 10))
                                        }
                                        Spacer()
                                        Text(chuRecord.judge_critical)
                                            .bold()
                                    }
                                }
                                
                                ZStack(alignment: .trailing) {
                                    Rectangle()
                                        .fill(Color.red.opacity(0.6))
                                        .frame(width: chuniWidthArray[1])
                                    
                                    HStack {
                                        Text("Justice")
                                        Spacer()
                                        Text(chuRecord.judge_justice)
                                            .bold()
                                    }
                                }
                                
                                ZStack(alignment: .trailing) {
                                    Rectangle()
                                        .fill(Color.green.opacity(0.6))
                                        .frame(width: chuniWidthArray[2])
                                    HStack {
                                        Text("Attack")
                                        Spacer()
                                        Text(chuRecord.judge_attack)
                                            .bold()
                                    }
                                }
                                
                                ZStack(alignment: .trailing) {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.6))
                                        .frame(width: chuniWidthArray[3])
                                    HStack {
                                        Text("Miss")
                                        Spacer()
                                        Text(chuRecord.judge_miss)
                                            .bold()
                                    }
                                }
                            }
                            .frame(width: chuniJudgeWidth)
                            .padding(.trailing)
                            
                            Spacer()
                            
                            VStack {
                                HStack {
                                    Text("Tap")
                                    Spacer()
                                    Text(chuRecord.note_tap ?? "")
                                }
                                HStack {
                                    Text("Hold")
                                    Spacer()
                                    Text(chuRecord.note_hold ?? "")
                                }
                                HStack {
                                    Text("Slide")
                                    Spacer()
                                    Text(chuRecord.note_slide ?? "")
                                }
                                HStack {
                                    Text("Air")
                                    Spacer()
                                    Text(chuRecord.note_air ?? "")
                                }
                                HStack {
                                    Text("Flick")
                                    Spacer()
                                    Text(chuRecord.note_flick ?? "")
                                }
                            }
                        }
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(chunithmLevelColor[3]!.opacity(0.4))
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            getCommonVar()
            if (mode == 0) {
                getChuniVar()
            }
            isLoaded.toggle()
        }
            
    }
    
    func getCommonVar() {
        requestURL = mode == 0 ? chunithmCoverSource == 0 ?  "https://raw.githubusercontent.com/Louiswu2011/Chunithm-Song-Cover/main/images/\(chuSong!.musicId).png" :  "https://gitee.com/louiswu2011/chunithm-cover/raw/master/image/\(chuSong!.musicId).png" :  "https://www.diving-fish.com/covers/\(getCoverNumber(id: maiSong!.musicId )).png"
        
        title = mode == 0 ? chuRecord.title : maiRecord.title
        artist = mode == 0 ? chuSong!.basicInfo.artist : maiSong!.basicInfo.artist
        playTime = mode == 0 ? chuRecord.getDateString() : maiRecord.getDateString()
        difficulty = mode == 0 ? chuRecord.diff.uppercased() : maiRecord.diff.uppercased()
        diffColor = mode == 0 ? chunithmLevelColor[chuRecord.getLevelIndex()]! : maimaiLevelColor[maiRecord.getLevelIndex()]!
        score = mode == 0 ? chuRecord.score : maiRecord.achievement
    }
    
    func getChuniVar() {
        chuniMaxCombo = Int(chuRecord.judge_critical)! + Int(chuRecord.judge_justice)! + Int(chuRecord.judge_attack)! + Int(chuRecord.judge_miss)!
        chuniWidthArray = getWidthForChuniJudge()
    }
    
    func getWidthForChuniJudge() -> Array<CGFloat> {
        let maxCombo = Int(chuRecord.judge_critical)! + Int(chuRecord.judge_justice)! + Int(chuRecord.judge_attack)! + Int(chuRecord.judge_miss)!
        var array: Array<CGFloat> = []
        array.append(CGFloat(Float(chuRecord.judge_critical)! / Float(maxCombo) * chuniJudgeWidth.asFloat()).cap(at: chuniJudgeWidth))
        array.append(CGFloat(Float(chuRecord.judge_justice)! / Float(maxCombo) * chuniJudgeWidth.asFloat()).cap(at: chuniJudgeWidth))
        array.append(CGFloat((Float(chuRecord.judge_attack)! / Float(maxCombo) * chuniJudgeWidth.asFloat()) + 1).cap(at: chuniJudgeWidth))
        array.append(CGFloat((Float(chuRecord.judge_miss)! / Float(maxCombo) * chuniJudgeWidth.asFloat()) + 1).cap(at: chuniJudgeWidth))
        
        return array
    }
    
    func getWidthForNote() {
        
    }
    
    
}

extension CGFloat {
    func cap(at: CGFloat) -> CGFloat {
        return self > at ? at : self
    }
    
    func asFloat() -> Float {
        return Float(self)
    }
}

struct RecentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecentDetailView()
    }
}
