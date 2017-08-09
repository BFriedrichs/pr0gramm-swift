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
  private static let controller = UIApplication.shared.keyWindow!.rootViewController!
  
  static func noNewerItem(){
    let alert = UIAlertController(title: "Hinweis", message: "Es gibt noch keine neueren Posts.\nAber zum Glück hast du bestimmt sowieso Besseres zu tun.", preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    controller.present(alert, animated: true, completion: nil)
  }
  
  static func noOlderItem(){
    let alert = UIAlertController(title: "Hinweis", message: "Es scheint keine älteren Posts zu geben.", preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    controller.present(alert, animated: true, completion: nil)
  }
  
  static func needsLogin(){
    let alert = UIAlertController(title: "Hinweis", message: "Diese Aktion erfordert Benutzerrechte. Möchtest du dich anmelden?", preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "Nein", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Zum Login", style: .default, handler: { action in
			controller.performSegue(withIdentifier: "ShowLoginSegue", sender: nil)
    }))

    controller.present(alert, animated: true, completion: nil)
  }
}
