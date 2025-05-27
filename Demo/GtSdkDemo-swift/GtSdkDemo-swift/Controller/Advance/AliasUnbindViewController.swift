//
//  AliasUnbindViewController.swift
//  GtSdkDemo-swift
//
//  Created by ak on 2020/03/20.
//  Copyright © 2020 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//

import UIKit
import GTSDK

class AliasUnbindViewController: UIViewController {
  
  @IBOutlet weak var ensureUnBindAliasBtn: UIButton!
  @IBOutlet weak var unBindAliasTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    ensureUnBindAliasBtn.layer.cornerRadius =  6
    unBindAliasTextField.attributedPlaceholder = NSAttributedString(string: unBindAliasTextField.placeholder ?? "", attributes: [.foregroundColor: UIColor.lightGray])
  }
  
  @IBAction func ensureUnBindAliasClick(_ sender: Any) {
    guard let alias = unBindAliasTextField.text, !alias.isEmpty else {
      UIAlertController.alert(title: "alias不能为空") 
      return
    }
    GeTuiSdk.unbindAlias(alias, andSequenceNum: "\(alias)-sign", andIsSelf: true)
    navigationController?.popViewController(animated: true)
  }
  
}
