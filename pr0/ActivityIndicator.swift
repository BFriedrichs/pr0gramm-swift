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
  
  static let shared = ActivityIndicator()
  
  var activity: UIActivityIndicatorView!
  
  private let size: CGFloat = 40
  
  private init() {
   
    activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    activity.color = Color.Highlight

    let backgroundView = UIView()
    backgroundView.backgroundColor = Color.Back.withAlphaComponent(0.8)
		backgroundView.frame = CGRect(x: -size / 2, y: -size / 2, width: size * 2, height: size * 2)
    backgroundView.layer.cornerRadius = 10
    backgroundView.layer.masksToBounds = true
    
    activity.insertSubview(backgroundView, at: 0)
    
    let x = UIScreen.main.bounds.width
    let y = UIScreen.main.bounds.height
    
    activity.frame = CGRect(x: x / 2 - size / 2, y: y / 2 - size / 2, width: size, height: size)
  }
  
  static func show() {
    UIApplication.shared.keyWindow?.addSubview(ActivityIndicator.shared.activity)
    ActivityIndicator.shared.activity.startAnimating()
  }
  
  static func hide() {
    DispatchQueue.main.async {
      ActivityIndicator.shared.activity.stopAnimating()
      ActivityIndicator.shared.activity.removeFromSuperview()
    }
  }
}
