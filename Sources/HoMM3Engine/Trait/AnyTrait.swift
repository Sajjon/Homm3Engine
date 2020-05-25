//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-25.
//

import Foundation

public struct AnyTrait: Trait, TraitInitializable, Hashable, CustomStringConvertible {
        
    public let uniqueName: CamelCasedStringAaZz
    public let displayName: String
    public let detailedDescription: String
    
    public init(
        uniqueName: CamelCasedStringAaZz,
        displayName: String,
        detailedDescription: String
    ) {
        self.uniqueName = uniqueName
        self.displayName = displayName
        self.detailedDescription = detailedDescription
    }
}

public extension AnyTrait {
    init<T>(trait: T) where T: Trait {
        self.init(uniqueName: trait.uniqueName, displayName: trait.displayName, detailedDescription: trait.detailedDescription)
    }
}

// MARK: Equatable
public extension AnyTrait {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.uniqueName == rhs.uniqueName
    }
}

// MARK: Hashable
public extension AnyTrait {
    func hash(into hasher: inout Hasher) {
        hasher.combine(uniqueName)
    }
}

// MARK: CustomStringConvertible
public extension AnyTrait {
    var description: String { displayName }
}
