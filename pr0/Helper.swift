//
//  Helper.swift
//  pr0
//
//  Created by Björn Friedrichs on 30.07.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

extension Array where Element: Equatable {
  mutating func remove(_ element: Element) {
    while let i = self.index(of: element) {
      self.remove(at: i)
    }
  }
}

extension UIView {
  func deepCopy__EXPENSIVE() -> UIView {
    return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! UIView
  }
}

func captureScreen() -> UIImage? {
  // prevent loading circle on screenshot -> subviews[0]
  let layer = UIApplication.shared.keyWindow!.subviews[0].layer
  let scale = UIScreen.main.scale
  UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
  
  layer.render(in: UIGraphicsGetCurrentContext()!)
  let screenshot = UIGraphicsGetImageFromCurrentImageContext()
  UIGraphicsEndImageContext()
  
  return screenshot
}

func getStringSizeForFont(font: UIFont, myText: String) -> CGSize {
  let fontAttributes = [NSFontAttributeName: font]
  let size = (myText as NSString).size(attributes: fontAttributes)
  
  return size
}
