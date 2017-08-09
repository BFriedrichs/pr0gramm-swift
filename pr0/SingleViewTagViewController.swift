//
//  SingleViewTagViewController.swift
//  pr0gramm
//
//  Created by Björn Friedrichs on 06.08.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation
import UIKit

class SingleViewTagViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  let reuseIdentifier = "tagCell"
  let api = API.shared

  @IBOutlet var tagView: UICollectionView!
  @IBOutlet var tagViewHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet var flowLayout: UICollectionViewFlowLayout!
  
  var mainController: SingleViewController!
  var item: Item!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tagView.delaysContentTouches = false
    
    for case let scrollView as UIScrollView in tagView.subviews {
      scrollView.delaysContentTouches = false
    }
    
    guard parent != nil && (parent as! SingleViewController).item != nil else {
      return
    }
    
    mainController = parent! as! SingleViewController
    item = mainController.item
    
    updateTags()
  }
  
  func updateTags() {
    self.api.itemService.getItemMeta(forItem: self.item, cb: { type in
      if type == .Tag {
        DispatchQueue.main.async {
          // force height to load all comments
          self.tagViewHeightConstraint.constant = 99999
          self.tagView.reloadData()
          self.updateViewConstraints()
        }
      }
    })
  }
  
  override func updateViewConstraints() {
    super.updateViewConstraints()
    DispatchQueue.main.async {
      self.tagViewHeightConstraint.constant = self.tagView.contentSize.height
      NotificationCenter.default.post(name: Notification.Name(rawValue: "tag"), object: nil)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard item != nil else {
      return 0
    }
    print("tags: \(item.tagStore.size)")
    return item.tagStore.size
  }

  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let index = indexPath[1]
    let tag = item.tagStore.storage[index]
    var size = (tag.tag as NSString).size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)])
    size.width += 20
    size.height += 5
    return size
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TagCell
    
    let index = indexPath[1]
    let tag = item.tagStore.storage[index]
  	
    cell.tag_ = tag
    cell.tagLabel.text = tag.tag
    
    cell.layer.cornerRadius = 5
    cell.layer.masksToBounds = true

    cell.updateSelection()
    
    return cell
  }
  
  // MARK: Delegate
  
  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as! TagCell
    
    let alert = UIAlertController(title: cell.tagLabel.text, message: "Für dieses Tag abstimmen.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Upvote", style: .default, handler: { action in
      let status = self.api.voteStore.getNextStatus(forElement: cell.tag_!, withTransition: .Upvote)
      
      self.api.tagService.vote(forTag: cell.tag_!, transitionTo: status, cb: { response in
        if response.needsLogin {
          Dialog.needsLogin()
        } else {
          cell.updateSelection()
        }
      })
    }))
    alert.addAction(UIAlertAction(title: "Downvote", style: .default, handler: { action in
      let status = self.api.voteStore.getNextStatus(forElement: cell.tag_!, withTransition: .Downvote)
      
      self.api.tagService.vote(forTag: cell.tag_!, transitionTo: status, cb: { response in
        if response.needsLogin {
          Dialog.needsLogin()
        } else {
          cell.updateSelection()
        }
      })
    }))
    
    alert.addAction(UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  // change background color when user touches cell
  func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath)!
    DispatchQueue.main.async {
      cell.layer.borderColor = Color.Highlight.cgColor
      cell.layer.borderWidth = 2
      cell.setNeedsDisplay()
    }
  }
  
  // change background color back when user releases touch
  func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath)!
    DispatchQueue.main.async {
    	cell.layer.borderColor = Color.BackLighter.cgColor
      cell.layer.borderWidth = 0
      cell.setNeedsDisplay()
    }
  }
}
