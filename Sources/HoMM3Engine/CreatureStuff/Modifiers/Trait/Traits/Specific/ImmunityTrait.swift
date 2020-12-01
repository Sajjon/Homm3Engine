//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-06-06.
//

import Foundation

public struct ImmunityTrait: SpecificTrait, Equatable, CustomStringConvertible {
    public struct SpecificContent: Equatable {
        public let effectImmuneAgainst: Modifier
        private let _equals: (Modifier) -> Bool
        public let displayName: String
        fileprivate init<M>(effect: M) where M: Modifier & Equatable {
            self.displayName = effect.displayName
            self.effectImmuneAgainst = effect
            self._equals = {
                guard let _effect = $0 as? M else {
                    return false
                }
                return _effect == effect
            }
        }
        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs._equals(rhs.effectImmuneAgainst) && rhs._equals(lhs.effectImmuneAgainst)
        }
    }
    public let info: AnyTrait
    public let specific: SpecificContent
    
    public init<M>(immuneAgainst effect: M, detailedDescription: String) where M: Modifier & Equatable {
        self.info = .init(
            uniqueName: "immunity",
            displayName: "Immune against \(effect.displayName)",
            detailedDescription: detailedDescription
        )
        self.specific = .init(effect: effect)
        
    }
}
