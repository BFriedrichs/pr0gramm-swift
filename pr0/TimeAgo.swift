//
//  TimeAgo.swift
//  pr0gramm
//
//  Created by Björn Friedrichs on 03.08.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation


// credit https://gist.github.com/heinrisch
func timeAgoSinceDate(_ date:Date, numericDates:Bool = false) -> String {
  let calendar = NSCalendar.current
  let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
  let now = Date()
  let earliest = now < date ? now : date
  let latest = (earliest == now) ? date : now
  let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
  
  if (components.year! >= 2) {
    return "vor \(components.year!) Jahren"
  } else if (components.year! >= 1){
    if (numericDates){
      return "vor 1 Jahr"
    } else {
      return "Letztes Jahr"
    }
  } else if (components.month! >= 2) {
    return "vor \(components.month!) Monaten"
  } else if (components.month! >= 1){
    if (numericDates){
      return "vor 1 Monat"
    } else {
      return "Letzten Monat"
    }
  } else if (components.weekOfYear! >= 2) {
    return "vor \(components.weekOfYear!) Wochen"
  } else if (components.weekOfYear! >= 1){
    if (numericDates){
      return "vor 1 Woche"
    } else {
      return "Letzte Woche"
    }
  } else if (components.day! >= 2) {
    return "vor \(components.day!) Tagen"
  } else if (components.day! >= 1){
    if (numericDates){
      return "vor 1 Tag"
    } else {
      return "Gestern"
    }
  } else if (components.hour! >= 2) {
    return "vor \(components.hour!) Stunden"
  } else if (components.hour! >= 1){
    if (numericDates){
      return "vor 1 Stunde"
    } else {
      return "vor einer Stunde"
    }
  } else if (components.minute! >= 2) {
    return "vor \(components.minute!) Minuten"
  } else if (components.minute! >= 1){
    if (numericDates){
      return "vor 1 Minute"
    } else {
      return "vor einer Minute"
    }
  } else if (components.second! >= 3) {
    return "vor \(components.second!) Sekunden"
  } else {
    return "Gerade"
  }
  
}
