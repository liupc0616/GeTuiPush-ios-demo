//
//  BadgeViewController.swift
//  GtSdkDemo-swift
//
//  Created by ak on 2020/03/20.
//  Copyright © 2020 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//

import UIKit
import GTSDK

class LiveActivityViewController: UIViewController {
  @IBOutlet weak var activityIdText: UITextField!
  @IBOutlet weak var segment: UISegmentedControl!
  
  var state: PrograssState = .Car
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "灵动岛交互";
  }
  
  @available(iOS 16.1, *)
  @IBAction func create() {
    let activityId = activityIdText.text ?? "new"
    if segment.selectedSegmentIndex == 0 {
      LiveActivityUtils.startActivity1(activityId: activityId)
    } else {
      LiveActivityUtils.startActivity2(activityId: activityId)
    }
  }
  
  @available(iOS 16.1, *)
  @IBAction func update() {
    self.state = PrograssState.init(rawValue: (self.state.rawValue + 1) % 4) ?? .Car
    if segment.selectedSegmentIndex == 0 {
      LiveActivityUtils.updateActivityState1(self.state.rawValue)
    } else {
      LiveActivityUtils.updateActivityState2(self.state.rawValue)
    }
  }
  
  @available(iOS 16.1, *)
  @IBAction func end() {
    if segment.selectedSegmentIndex == 0 {
      LiveActivityUtils.endPreActivity1()
    } else {
      LiveActivityUtils.endPreActivity2()
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
}
