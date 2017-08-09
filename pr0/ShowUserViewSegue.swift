//
//  ShowUserViewSegue.swift
//  pr0gramm
//
//  Created by Björn Friedrichs on 09.08.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation
import UIKit

class ShowUserViewSegue: UIStoryboardSegue {
  override func perform() {
    let destination = (self.destination as! UserViewController)
    let source = self.source
    
    source.navigationController!.pushViewController(destination, animated: true)
  }
}
