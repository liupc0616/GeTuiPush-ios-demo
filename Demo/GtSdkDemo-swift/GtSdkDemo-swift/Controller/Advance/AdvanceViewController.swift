//
//  AdvanceViewController.swift
//  GtSdkDemo-swift
//
//  Created by ak on 2020/03/20.
//  Copyright © 2020 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//

import UIKit
import GTSDK

class AdvanceViewController: UIViewController {
  
  @IBOutlet weak var bindAliasView: UIView!
  @IBOutlet weak var unbindAliasView: UIView!
  @IBOutlet weak var setTagView: UIView!
  @IBOutlet weak var sendMessageView: UIView!
  @IBOutlet weak var setBadgeView: UIView!
  @IBOutlet weak var resetBadgeView: UIView!
  @IBOutlet weak var runBackgroundEnableSwitch: UISwitch!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var sdkStateLabel: UILabel!
  @IBOutlet weak var liveActivityView: UIView!
  @IBOutlet weak var controlsView: UIView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "高级功能"
    addGestureRecognizer()
    updateStatusView()
    NotificationCenter.default.addObserver(self, selector: #selector(updateStatusView), name: .GTSDKState, object: nil)
  }
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc func updateStatusView() {
    sdkStateLabel.text = GeTuiSdk.status().title
  }
  
  func addGestureRecognizer() {
    bindAliasView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bindAliasClick)))
    unbindAliasView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(unBindAliasClick)))
    setTagView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setTagClick)))
    sendMessageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendMessageClick)))
    setBadgeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setBadgeClick)))
    resetBadgeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resetBadgeClick)))
    liveActivityView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(liveActivityClick)))
    controlsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(controlsClick)))
    
    
  }
  
  @objc func bindAliasClick() {
    navigationController?.pushViewController(AliasViewController(), animated: false)
  }
  
  @objc func unBindAliasClick() {
    navigationController?.pushViewController(AliasUnbindViewController(), animated: false)
  }
  
  @objc func setTagClick() {
    navigationController?.pushViewController(TagViewController(), animated: false)
  }
  
  @objc func sendMessageClick() {
    navigationController?.pushViewController(MessageViewController(), animated: false)
  }
  
  @objc func setBadgeClick() {
    navigationController?.pushViewController(BadgeViewController(), animated: false)
  }
  
  @objc func resetBadgeClick() {
    GeTuiSdk.resetBadge()
    UIApplication.shared.applicationIconBadgeNumber = 0
    UIAlertController.alert(title: "复位角标成功")
  }
  
  @IBAction func runBackgroundEnable(_ sender: Any) {
    GeTuiSdk.runBackgroundEnable(runBackgroundEnableSwitch.isOn)
  }
  
  @objc func liveActivityClick() {
    navigationController?.pushViewController(LiveActivityViewController(), animated: false)
  }
  
  @objc func controlsClick() {
    if #available(iOS 18.0, *) {
      ControlsCenterUtils.getTokens { tokens in
        GeTuiSdk.registerControlsTokens(tokens, sequenceNum: "sn1")
        DispatchQueue.main.async {
          UIAlertController.alert(title: "注册Controls Token", msg: tokens.description)
        }
      }
    }
  }
  
}
