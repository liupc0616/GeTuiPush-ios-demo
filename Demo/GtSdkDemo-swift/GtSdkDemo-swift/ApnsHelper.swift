//
//  ApnsHelper.swift
//  ApnsDemo
//
//  Created by ak on 2020/4/14.
//  Copyright © 2020 ak. All rights reserved.
//

import UIKit

struct ApnsHelper {
  static func makeMp3FromExt(_ cnt: Double) -> String {
    let path = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.ent.com.getui.demo")!.absoluteString.replacingOccurrences(of: "file://", with: "") + "Library/Sounds/"
    return mergeVoice(libPath: path, cnt)
  }
  
  private static func mergeVoice(libPath: String, _ cnt: Double) -> String {
//    var nums = [String]()
//    var tmp = Int(cnt)
//    while(tmp>0) {
//      nums.insert("\(tmp % 10)", at: 0)
//      tmp = Int(tmp/10)
//    }
    //TODO: 需自行替换资源
    var mergeData = Data()
    ["tip", "tip"].forEach { num in
      let mp3Url = Bundle.main.url(forResource: "\(num).mp3", withExtension: "")
      if let mp3Url = mp3Url, let data = try? Data(contentsOf: mp3Url) {
        mergeData.append(data)
      }
    }
    guard !mergeData.isEmpty else { return "" }
    if !FileManager.default.fileExists(atPath: libPath) {
      do {
        try FileManager.default.createDirectory(atPath: libPath, withIntermediateDirectories: true, attributes: nil)
      } catch {
        NSLog("创建Sounds文件失败 \(libPath)")
      }
    }
    let fileName = "\(getFileName()).mp3"
    let fileUrl = URL(string: "file://\(libPath)\(fileName)")
    guard let url = fileUrl else { return "" }
    do {
      try mergeData.write(to: url)
    } catch {
      NSLog("合成mp3文件失败 \(url)")
    }
    return fileName
  }
    
  private static func getFileName() -> Int {
    return Int(arc4random()%100000)
  }
}
