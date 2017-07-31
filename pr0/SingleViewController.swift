//
//  SingleViewController.swift
//  pr0
//
//  Created by Björn Friedrichs on 30.07.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation
import UIKit

class SingleViewController: UIViewController, UIScrollViewDelegate {
  
  var initSize: CGRect?
  var initImage: UIImage?
  
  var willClose = false
  
  @IBOutlet var contentView: UIScrollView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.hidesBackButton = true
    
    let label1 = UILabel.init()
    label1.text = "Test1"
    label1.frame = CGRect.init(x: 10, y: 10, width: 200, height: 50)
    
    let label2 = UILabel.init()
    label2.text = "Test2"
    label2.frame = CGRect.init(x: 10, y: 1000, width: 200, height: 50)
    
    
    contentView.addSubview(label1)
    contentView.addSubview(label2)
    
    contentView.decelerationRate = UIScrollViewDecelerationRateFast
    contentView.contentSize = CGSize(width: view.frame.width, height: 1000)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetTop = scrollView.contentOffset.y
    if view.frame.minY > 0 || offsetTop < 0 {
      scrollView.contentOffset.y = 0
      self.view.frame = CGRect(origin: CGPoint(x: 0, y: self.view.frame.minY-offsetTop), size: self.view.frame.size)
    }
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    animateBack()
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    let offsetTop = view.frame.minY
    let viewHeight = view.bounds.height
    if offsetTop > viewHeight / 3.5 {
      print("go back")
      willClose = true
      performSegue(withIdentifier: "GalleryViewSegue", sender: nil)
    } else {
      animateBack()
    }
  }
  
  var isAnimating = false
  func animateBack() {
    if !willClose && self.view.frame.minY > 0 {
      UIView.animate(withDuration: 0.3, animations: { () -> Void in
        self.view.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: self.view.frame.size)
      }) { (Finished) -> Void in
        self.isAnimating = false
      }
    }
  }
}
