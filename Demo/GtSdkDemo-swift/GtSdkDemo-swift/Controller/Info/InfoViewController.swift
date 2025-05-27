//
//  InfoViewController.swift
//  GtSdkDemo-swift
//
//  Created by ak on 2020/03/20.
//  Copyright © 2020 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//

import UIKit
import GTSDK

class InfoViewController: UIViewController {
  
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var appidLabel: UILabel!
    @IBOutlet weak var appkeyLabel: UILabel!
    @IBOutlet weak var appsecretLabel: UILabel!
    @IBOutlet weak var packageNameLabel: UILabel!
    @IBOutlet weak var sdkVersionLabel: UILabel!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var iphoneSysVersionLabel: UILabel!
    @IBOutlet weak var deviceModelLabel: UILabel!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        appidLabel.text = kGtAppId
        appkeyLabel.text = kGtAppKey
        appsecretLabel.text = kGtAppSecret
        let dic = Bundle.main.infoDictionary ?? [:]
        appNameLabel.text = dic["CFBundleName"] as? String
        deviceNameLabel.text = UIDevice.current.systemName
        iphoneSysVersionLabel.text = UIDevice.current.systemVersion
        deviceModelLabel.text = UIDevice.current.model
        packageNameLabel.text = dic["CFBundleIdentifier"] as? String
        sdkVersionLabel.text = GeTuiSdk.version()
    }
}
