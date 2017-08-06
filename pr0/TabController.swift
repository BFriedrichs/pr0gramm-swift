//
//  NavigationController.swift
//  pr0
//
//  Created by Björn Friedrichs on 30.07.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation
import UIKit

class TabController: UITabBarController, UITabBarControllerDelegate {
  
  let settings = SettingsStore.sharedInstance
  
  var _isVisible = true
  var isVisible: Bool {
    get {
      return _isVisible
    }
    set {
      if _isVisible != newValue {
        _isVisible = newValue
        let direction: CGFloat = newValue ? -1 : 1
        UIView.animate(withDuration: 0.25, delay: 0.18, animations: {
          //
          self.tabBar.frame.origin = CGPoint(x: 0, y: self.tabBar.frame.minY + (self.tabBar.frame.height + 1) * direction)
        })
      }
    }
  }
  
  @IBOutlet var toggleAudioButton: UIBarButtonItem!
  @IBAction func toggleAudio(_ sender: UIBarButtonItem) {
    settings.audio = !settings.audio
    sender.image = self.settings.audio ? #imageLiteral(resourceName: "audio_on") : #imageLiteral(resourceName: "audio_off")
  }
  
  override func viewDidLoad() {
    self.delegate = self
    self.navigationController!.navigationBar.subviews.first?.alpha = 0.95
    self.toggleAudioButton.image = self.settings.audio ? #imageLiteral(resourceName: "audio_on") : #imageLiteral(resourceName: "audio_off")
  
    deleteUnusedViews()
  }
  
  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    let tabViewControllers = tabBarController.viewControllers!
    guard let toIndex = tabViewControllers.index(of: viewController) else {
      return false
    }
    
    let fromView = selectedViewController!.view!
    let toView = tabViewControllers[toIndex].view!
    
    guard fromView != toView else {
      return false
    }
    
    let screenWidth = fromView.frame.width
    let screenHeight = fromView.frame.height
    
    fromView.superview!.addSubview(toView)
    toView.addSubview(fromView)
    
    var startAt = screenWidth
    
    if toIndex == 0 {
      startAt = -startAt
    }
    
    toView.frame = CGRect(x: startAt, y: 0, width: screenWidth, height: screenHeight)
    
    fromView.frame = CGRect(x: -startAt, y: 0, width: screenWidth, height: screenHeight)

    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 2.5, options: .curveEaseOut, animations: { () -> Void in
      toView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    }) { finished in
      fromView.removeFromSuperview()
     
      self.selectedIndex = toIndex
      self.view.isUserInteractionEnabled = true
    }
		
    return true
  }
  
  var cleanDone = false
  
  func deleteUnusedViews() {
    if !self.cleanDone {
      var removeCount = 0
      for (_, eachView) in (self.tabBar.subviews.enumerated()) {
        if NSStringFromClass(eachView.classForCoder).range(of: "_UITabBarBackgroundView") != nil {
          eachView.removeFromSuperview()
          removeCount += 1
        }
        if NSStringFromClass(eachView.classForCoder).range(of: "UIImageView") != nil {
          eachView.removeFromSuperview()
          removeCount += 1
        }
        if removeCount == 2 {
          self.cleanDone = true
          break
        }
      }
    }
  }
}
