//
//  ActivityIndicator.swift
//  pr0
//
//  Created by Björn Friedrichs on 31.07.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicator {
  
  static let sharedInstance = ActivityIndicator()
  
  var activity: UIActivityIndicatorView!
  
  private let size: CGFloat = 40
  
  private init() {
   
    activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    let x = UIScreen.main.bounds.width
    let y = UIScreen.main.bounds.height
    
    activity.frame = CGRect(x: x / 2 - size / 2, y: y / 2 - size / 2, width: size, height: size)
  }
  
  static func show() {
    DispatchQueue.main.async {
      UIApplication.shared.keyWindow?.addSubview(ActivityIndicator.sharedInstance.activity)
      ActivityIndicator.sharedInstance.activity.startAnimating()
    }
  }
  
  static func hide() {
    DispatchQueue.main.async {
      ActivityIndicator.sharedInstance.activity.stopAnimating()
      ActivityIndicator.sharedInstance.activity.removeFromSuperview()
    }
  }
}
