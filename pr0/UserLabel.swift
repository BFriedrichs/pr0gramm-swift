//
//  UserLabel.swift
//  pr0gramm
//
//  Created by Björn Friedrichs on 06.08.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation
import UIKit

class UserLabel: UILabel {

  func setUser(userName: String, status: UserStatus, isOp: Bool = false) {
   	var result = "\(userName) ●"
    let userAttribute: [String : Any] = [NSForegroundColorAttributeName: mapMarkToColor(status: status)]
    let opAttribute: [String : Any] = [NSForegroundColorAttributeName: Color.Highlight]
    
    if isOp {
      result = "OP  \(result)"
    }
    
    let attributed = NSMutableAttributedString(string: result)
    attributed.addAttributes(userAttribute, range: (result as NSString).range(of: "●"))
    attributed.addAttributes(opAttribute, range: (result as NSString).range(of: "OP  "))

    self.attributedText = attributed
    self.sizeToFit()
    self.setNeedsLayout()
    self.layoutIfNeeded()
  }
}
