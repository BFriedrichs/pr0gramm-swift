//
//  Color.swift
//  pr0
//
//  Created by Björn Friedrichs on 29.07.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation
import UIKit

struct Color {
  static let Back = UIColor(22, 22, 22)
  static let Highlight = UIColor(238, 77, 46)
  static let Text = UIColor(136, 136, 136)
}

extension UIColor {
  convenience init(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) {
    self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
  }
}
