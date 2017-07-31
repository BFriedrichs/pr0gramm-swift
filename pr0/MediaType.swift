//
//  MediaTypes.swift
//  pr0
//
//  Created by Björn Friedrichs on 31.07.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation

enum MediaGroup {
  case ImageType, VideoType, UnknownType
}

enum MediaType: String {
  case png = "png", jpg = "jpg", jpeg = "jpeg", mp4 = "mp4", webm = "webm", gif = "gif", unknown = "unknown"


  public var mediaGroup: MediaGroup {
    switch self {
    case .png, .jpg, .jpeg, .gif: return .ImageType
    case .mp4, .webm: return .VideoType
    default: return .UnknownType
    }
  }
  
  static func getMediaType(forURL url: String) -> MediaType {
    return MediaType(rawValue: url.components(separatedBy: ".").last!) ?? .unknown
  }
}
