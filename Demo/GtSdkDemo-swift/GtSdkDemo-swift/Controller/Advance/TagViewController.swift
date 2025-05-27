//
//  TagViewController.swift
//  GtSdkDemo-swift
//
//  Created by ak on 2020/03/20.
//  Copyright © 2020 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//

import UIKit
import GTSDK

class TagViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
  @IBOutlet weak var addTagsView: UIView!
  @IBOutlet weak var tagTableView: UITableView!
  @IBOutlet weak var ensureSetBtn: UIButton!
  
  var tags = [String]()
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Tag设置"
    addTagsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addTagsClick)))
  }
  
  @objc func addTagsClick() {
    let alertController = UIAlertController(title: "添加Tag", message: nil, preferredStyle: UIAlertController.Style.alert)
    let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
    let sureAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.default) { [weak self] _ in
      guard let textField = alertController.textFields?.first, let tag = textField.text, !tag.isEmpty else {
        UIAlertController.alert(title: "请输入tag")
        return
      }
      self?.tags.append(tag)
      self?.tagTableView.reloadData()
    }
    alertController.addAction(sureAction)
    alertController.addAction(cancelAction)
    alertController.addTextField { (textField: UITextField!) in
      textField.placeholder = "请输入tag"
    }
    present(alertController, animated: true, completion: nil)
  }
  
  @IBAction func ensureSetTagClick(_ sender: Any) {
    guard !tags.isEmpty else {
      UIAlertController.alert(title: "tags不能为空")
      return
    }
    //tag只能包含中文字符、英文字母、0-9、+-*.的组合（不支持空格）
    GeTuiSdk.setTags(tags, andSequenceNum: "seqtag-1")
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tags.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: UITableViewCell.CellStyle.value2, reuseIdentifier: "cell")
    cell.backgroundColor = .white
    cell.textLabel?.text = tags[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
  
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if (editingStyle == UITableViewCell.EditingStyle.delete) {
      let alertController = UIAlertController(title: "提示", message: "是否确认删除", preferredStyle: UIAlertController.Style.alert)
      let sureAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.default) { [weak self] (_) in
        self?.tags.remove(at: indexPath.row)
        self?.tagTableView.reloadData()
      }
      let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
      alertController.addAction(sureAction)
      alertController.addAction(cancelAction)
      present(alertController, animated: true, completion: nil)
    }
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
    return "删除"
  }
  
  func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
    return false
  }
  
}

