//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-25.
//

import Foundation

public protocol SpecificTrait: Trait {
    associatedtype SpecificContent
    var info: AnyTrait { get }
}

public extension SpecificTrait {
    var uniqueName: CamelCasedStringAaZz { info.uniqueName }
    var displayName: String { info.displayName }
    var detailedDescription: String { info.detailedDescription }
}

public extension SpecificTrait where Self: CustomStringConvertible {
    var description: String {
        displayName
    }
    
    var name: String {
          displayName
      }
}
