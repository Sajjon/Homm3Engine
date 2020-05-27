//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-25.
//

import Foundation

public struct TraitRanged: SpecificTrait, Hashable, Codable, CustomStringConvertible {
    public struct SpecificContent: Hashable, Codable {
        public let ammo: UInt
    }
    public let info: AnyTrait
    public let specific: SpecificContent
    
    public init(ammo: UInt) {
        self.info = .init(
            uniqueName: "ranged",
            displayName: "Ranged",
            detailedDescription: "Allows this creature to attack without engaging into hand-to-hand combat. Visually typical ranged creature is armed with bows, e.g. Archers and Elves, but there are also several creatures, that use some kind of magic or elements (lightning, etc.), like Monks or Titans."
        )
        self.specific = .init(ammo: ammo)
        
    }
}

public extension TraitRanged {
    init(from decoder: Decoder) throws {
        fatalError()
    }
    func encode(to encoder: Encoder) throws {
        fatalError()
    }
}
