//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-26.
//

import Foundation

public extension Hero {
    struct HeroClass: Hashable, Codable {
        public let name: String
        public let nativeFaction: Faction
        public let startingPrimarySkills: Hero.PrimarySkills
    }
}
