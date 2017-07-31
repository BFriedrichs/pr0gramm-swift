//
//  Helper.swift
//  pr0
//
//  Created by Björn Friedrichs on 30.07.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation
import UIKit


extension Array where Element: Equatable {
  mutating func remove(_ element: Element) {
    while let i = self.index(of: element) {
      self.remove(at: i)
    }
  }
}
