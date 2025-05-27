//
//  MessageViewController.swift
//  GtSdkDemo-swift
//
//  Created by ak on 2020/03/20.
//  Copyright © 2020 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//

import UIKit
import GTSDK

class MessageViewController: UIViewController {
  
  @IBOutlet weak var messageTextField: UITextField!
  @IBOutlet weak var ensureSendMessageBtn: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "发送上行消息"
    ensureSendMessageBtn.layer.cornerRadius = 6
    messageTextField.attributedPlaceholder = NSAttributedString(string: messageTextField.placeholder ?? "", attributes: [.foregroundColor: UIColor.lightGray])
  }
  
  @IBAction func ensureSendClick(_ sender: Any) {
    guard let text = messageTextField.text, let data = text.data(using: .utf8) else { return }
    let msgId = try? GeTuiSdk.sendMessage(data)
    NSLog(msgId ?? "")
  }
  
}
