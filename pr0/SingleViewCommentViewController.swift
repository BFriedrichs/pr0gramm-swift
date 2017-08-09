//
//  SingleViewCommentViewController.swift
//  pr0gramm
//
//  Created by Björn Friedrichs on 04.08.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation
import UIKit

class SingleViewCommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  var mainController: SingleViewController!
  var item: Item!
  
  var api = API.shared
  
  @IBOutlet var tableView: UITableView!
  @IBOutlet var tableViewHeightConstraint: NSLayoutConstraint!
  
  let reuseIdentifier = "commentCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard parent != nil && (parent as! SingleViewController).item != nil else {
      return
    }
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 44
		
    mainController = parent! as! SingleViewController
    item = mainController.item
    updateComments()
  }
  
  func updateComments() {
    self.api.itemService.getItemMeta(forItem: self.item, cb: { type in
      if type == .Comment {
        DispatchQueue.main.async {
          // force height to load all comments
          self.tableViewHeightConstraint.constant = 99999
          self.tableView.reloadData()
          self.updateViewConstraints()
        }
      }
    })
  }
  
  override func updateViewConstraints() {
    super.updateViewConstraints()
    DispatchQueue.main.async {
    	self.tableViewHeightConstraint.constant = self.tableView.contentSize.height
      // print("height: \(self.tableView.contentSize.height)")
      NotificationCenter.default.post(name: Notification.Name(rawValue: "comment"), object: nil)
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard item != nil else {
      return 0
    }
    print("comments: \(item.commentStore.size)")
    return item.commentStore.size
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CommentCell

    let comments = item.commentStore.getComments()
    let ind = indexPath[1]
    let comment = comments[ind]
  	let cellInset = 12
    
    cell.comment = comment
    cell.commentLabel.text = comment.content
    cell.commentInsetConstraint.constant = CGFloat(comment.depth * cellInset)
    cell.user.setUser(userName: comment.user, status: comment.mark, isOp: comment.user == item.user)
    
    cell.points.text = "\(comment.up - comment.down)"
    cell.time.text = "\(timeAgoSinceDate(comment.createdDate, numericDates: true))"
		
    cell.updateSelection()
    
    if comments.count > ind + 1 {
      cell.separatorInset = UIEdgeInsets.init(top: 0, left: CGFloat(48 + comment.depth * cellInset), bottom: 0, right: 0)
    } else {
      cell.separatorInset = UIEdgeInsets.init(top: 0, left: 9999, bottom: 0, right: 0)
    }

    //print("row \(indexPath[1]): \(cell.frame.height)")
    
    return cell
  }

}
