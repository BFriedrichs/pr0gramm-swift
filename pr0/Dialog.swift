//
//  Dialog.swift
//  pr0
//
//  Created by Björn Friedrichs on 31.07.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation
import UIKit

class Dialog {
  static func noNewerItem(_ controller: UIViewController){
    let alert = UIAlertController(title: "Hinweis", message: "Es gibt noch keine neueren Posts.\nAber zum Glück hast du bestimmt sowieso Besseres zu tun.", preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    controller.present(alert, animated: true, completion: nil)
  }
  
  static func noOlderItem(_ controller: UIViewController){
    let alert = UIAlertController(title: "Hinweis", message: "Es scheint keine älteren Posts zu geben.", preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    controller.present(alert, animated: true, completion: nil)
  }
}
