//
//  ShowLoginViewSegue.swift
//  pr0gramm
//
//  Created by Björn Friedrichs on 09.08.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation
import UIKit

class ShowLoginViewSegue: UIStoryboardSegue {
  override func perform() {
    
    let destination = (self.destination as! UserLoginViewController)
    let source = self.source
    
    destination.modalPresentationStyle = .popover
    
    let nav = UINavigationController(rootViewController: destination)
    nav.modalPresentationStyle = .popover
    nav.navigationBar.barStyle = .blackTranslucent
    
    source.present(nav, animated: true, completion: nil)
  }
}
