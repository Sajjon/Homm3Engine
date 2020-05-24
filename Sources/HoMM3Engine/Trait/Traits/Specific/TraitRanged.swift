//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-25.
//

import Foundation

public struct TraitRanged: SpecificTrait {
    public struct SpecificContent {
        public let ammo: UInt
    }
    public let description: AnyTrait
    public let specific: SpecificContent
    
    public init(ammo: UInt) {
        self.description = .init(
            uniqueName: "ranged",
            displayName: "Ranged",
            detailedDescription: "Allows this creature to attack without engaging into hand-to-hand combat. Visually typical ranged creature is armed with bows, e.g. Archers and Elves, but there are also several creatures, that use some kind of magic or elements (lightning, etc.), like Monks or Titans."
        )
        self.specific = .init(ammo: ammo)
    }
}
