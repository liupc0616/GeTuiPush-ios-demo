//
//  AliasViewController.swift
//  GtSdkDemo-swift
//
//  Created by ak on 2020/03/20.
//  Copyright © 2020 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//

import UIKit
import GTSDK

class AliasViewController: UIViewController {
  
  @IBOutlet weak var bindAliasTextField: UITextField!
  @IBOutlet weak var ensureBindAliasBtn: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "绑定别名"
    ensureBindAliasBtn.layer.cornerRadius = 6
    bindAliasTextField.attributedPlaceholder = NSAttributedString(string: bindAliasTextField.placeholder ?? "", attributes: [.foregroundColor: UIColor.lightGray])
  }
  
  @IBAction func bindAliasClick(_ sender: Any) {
    guard let alias = bindAliasTextField.text, !alias.isEmpty else {
      UIAlertController.alert(title: "alias不能为空")
      return
    }
    GeTuiSdk.bindAlias(alias, andSequenceNum: "\(alias)-sign")
    navigationController?.popViewController(animated: true)
  }
  
}
