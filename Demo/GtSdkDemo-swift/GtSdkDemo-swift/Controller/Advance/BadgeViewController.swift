//
//  BadgeViewController.swift
//  GtSdkDemo-swift
//
//  Created by ak on 2020/03/20.
//  Copyright © 2020 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//

import UIKit
import GTSDK

class BadgeViewController: UIViewController {
  
  @IBOutlet weak var badgeTextField: UITextField!
  @IBOutlet weak var ensureSetBadgeBtn: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "同步角标"
    ensureSetBadgeBtn.layer.cornerRadius = 6
    badgeTextField.attributedPlaceholder = NSAttributedString(string: badgeTextField.placeholder ?? "", attributes: [.foregroundColor: UIColor.lightGray])
  }
  
  @IBAction func ensureSetBadgeClick(_ sender: Any) {
    guard let txt = badgeTextField.text, let badge = Int(txt) else { return }
     GeTuiSdk.setBadge(UInt(badge)) 
    if #available(iOS 16.0, *) {
        UNUserNotificationCenter.current().setBadgeCount(0)
    } else {
        UIApplication.shared.applicationIconBadgeNumber = badge
    }
    UIAlertController.alert(title: "设置成功")
  }
  
}
