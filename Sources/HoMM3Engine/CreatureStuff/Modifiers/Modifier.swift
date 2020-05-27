//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-25.
//

import Foundation

/// E.g. `Trait` or `Spell` (or `Artifact`?)
public protocol Modifier {
    var displayName: String { get }
}
//
//public struct AnyModifier: Codable, Hashable, Modifier, CustomStringConvertible {
//    public let displayName: String
//    
//    public init<Concrete>(_ concrete: Concrete) where Concrete: Modifier {
//        self.displayName = concrete.displayName
//    }
//}

public extension Modifier where Self: CustomStringConvertible {
    var description: String { displayName }
}
