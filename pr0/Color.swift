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
  static let BackLighter = UIColor(42, 46, 49)
  static let Highlight = UIColor(238, 77, 46)
  
  static let Text = UIColor(245, 247, 246)
  static let DarkText = UIColor(187, 187, 187)
  static let DarkerText = UIColor(136, 136, 136)
  
  static let Url = UIColor(117, 192, 199)
  static let HighlightBlue = UIColor(0, 143, 255)
  
  static let SFW = UIColor(92, 184, 92)
  static let NSFW = UIColor(240, 173, 78)
  static let NSFL = UIColor(217, 83, 79)
  
  static let Banned = UIColor(68, 68, 68)
  static let Fliese = UIColor(108, 67, 43)
  static let Newfag = UIColor(225, 8, 233)
  static let Fag = UIColor(255, 255, 255)
  static let Donator = UIColor(28, 185, 146)
  static let Oldfag = UIColor(91, 185, 28)
  static let SecrectSanta = UIColor(28, 185, 146)
  static let Mod = UIColor(0, 143, 255)
  static let Admin = UIColor(255, 153, 0)
  static let Legend = UIColor(28, 185, 146)
}

func mapMarkToColor(status: UserStatus) -> UIColor {
  switch status {
  case .Banned: return Color.Banned
  case .Fliese: return Color.Fliese
  case .Newfag: return Color.Newfag
  case .Fag: return Color.Fag
  case .Donator: return Color.Donator
  case .Oldfag: return Color.Oldfag
  case .SecretSanta: return Color.SecrectSanta
  case .Mod: return Color.Mod
  case .Admin: return Color.Admin
  case .Legend: return Color.Legend
  }
}

extension UIColor {
  convenience init(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) {
    self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
  }
}
