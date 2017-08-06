//
//  SingleViewInfoViewController.swift
//  pr0gramm
//
//  Created by Björn Friedrichs on 03.08.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation
import UIKit

class SingleViewInfoViewController: UIViewController {
  
  @IBOutlet var fav: UIButton!
  @IBOutlet var upvote: UIButton!
  @IBOutlet var downvote: UIButton!
  @IBOutlet var benis: UILabel!
  @IBOutlet var uploaded: UILabel!
  @IBOutlet var user: UserLabel!
  
  var mainController: SingleViewController!
  var item: Item!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    uploaded.textColor = Color.DarkText
    user.textColor = Color.Text
    
    guard parent != nil && (parent as! SingleViewController).item != nil else {
      return
    }
    
    mainController = parent! as! SingleViewController
    item = mainController.item
    updateInfo()
  }
  
  func updateInfo() {
    let dateDiff = Date().timeIntervalSince(item.createdDate)
    let benisString = dateDiff < 3600 ? " ∙∙∙" : "\(item.up - item.down)"
    benis.textColor = dateDiff < 3600 ? Color.DarkText : Color.Text
    let uploadedString = "\(timeAgoSinceDate(self.item.createdDate)) von "

    DispatchQueue.main.async {
      self.uploaded.text = uploadedString
      self.user.setUser(userName: self.item.user, status: self.item.mark)
      self.benis.text = benisString
      self.view.sizeToFit()
    }
  }
  
  @IBAction func tappedFavorite(_ sender: UIButton) {
    if !sender.isSelected {
      let anim = UIImageView(image: #imageLiteral(resourceName: "fav_on"))
      sender.addSubview(anim)
      anim.frame = CGRect(x: sender.frame.width / 2, y: sender.frame.height / 2, width: 0, height: 0)
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
        anim.frame = CGRect(x: 0, y: 0, width: sender.frame.width, height: sender.frame.height)
      }) { finished in
        anim.removeFromSuperview()
        sender.isSelected = true
      }
    } else {
      sender.isSelected = false
    }
  }
  
  @IBAction func tappedMinus(_ sender: UIButton) {
		sender.isSelected = !sender.isSelected
  }
  
  @IBAction func tappedPlus(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
  }
  
  
}
