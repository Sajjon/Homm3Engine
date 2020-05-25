//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-25.
//

import Foundation

fileprivate let badChars = CharacterSet.alphanumerics.inverted

internal extension String {
    
    var uppercasingFirst: String {
        prefix(1).uppercased() + dropFirst()
    }
    
    var lowercasingFirst: String {
        prefix(1).lowercased() + dropFirst()
    }

    var camelized: String {
          guard !isEmpty else {
              return ""
          }

          let parts = components(separatedBy: badChars)

          let first = String(describing: parts.first!).lowercasingFirst
          let rest = parts.dropFirst().map({String($0).uppercasingFirst})

          return ([first] + rest).joined(separator: "")
      }
}
