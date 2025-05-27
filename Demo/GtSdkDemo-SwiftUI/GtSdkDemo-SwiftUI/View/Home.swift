//
//  Home.swift
//  GtSdkDemo-SwiftUI
//
//  Created by ak on 2021/8/6.
//

import SwiftUI
import GTSDK

struct Home: View {
  var body: some View {
    VStack {
        Text("GTSDK:\(GeTuiSdk.version())")
    }
  }
  
  func logMsg(_ str: String) {
    print(str)
  }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
