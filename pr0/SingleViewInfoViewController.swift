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
  let api = API.shared
  
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
    
    updateSelection()
  }
  
  func updateSelection() {
    let status = api.voteStore.getVote(forElement: self.item)
    DispatchQueue.main.async {
    	self.downvote.isSelected = false
    	self.upvote.isSelected = false
    	self.fav.isSelected = false
    
    	switch status {
    	case .Like:
    	  let anim = UIImageView(image: #imageLiteral(resourceName: "fav_on"))
   	   	self.fav.addSubview(anim)
    	  anim.frame = CGRect(x: self.fav.frame.width / 2, y: self.fav.frame.height / 2, width: 0, height: 0)
   	   	UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
        	anim.frame = CGRect(x: 0, y: 0, width: self.fav.frame.width, height: self.fav.frame.height)
      	}) { finished in
        	anim.removeFromSuperview()
        	self.fav.isSelected = true
      	}
				self.upvote.isSelected = true
      	break;
    	case .Upvote:
      	self.upvote.isSelected = true
      	break;
    	case .Downvote:
      	self.downvote.isSelected = true
      default: break
    	}
    }
  }
  
  @IBAction func tappedFavorite(_ sender: UIButton) {
    let status = api.voteStore.getNextStatus(forElement: item, withTransition: .Like)
    
    self.api.itemService.vote(forItem: self.item, transitionTo: status, cb: { response in
      if response.needsLogin {
        Dialog.needsLogin()
      } else {
        self.updateSelection()
      }
    })
  }
  
  @IBAction func tappedMinus(_ sender: UIButton) {
    let status = api.voteStore.getNextStatus(forElement: item, withTransition: .Downvote)
    
    self.api.itemService.vote(forItem: self.item, transitionTo: status, cb: { response in
      if response.needsLogin {
        Dialog.needsLogin()
      } else {
				self.updateSelection()
      }
    })
  }
  
  @IBAction func tappedPlus(_ sender: UIButton) {
  	let status = api.voteStore.getNextStatus(forElement: item, withTransition: .Upvote)
    
    self.api.itemService.vote(forItem: self.item, transitionTo: status, cb: { response in
      if response.needsLogin {
        Dialog.needsLogin()
      } else {
        self.updateSelection()
      }
    })
  }
}
