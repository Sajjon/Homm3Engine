//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-25.
//

import Foundation

public extension Battlefield {
    struct Trait: HoMM3Engine.Trait, TraitInitializable {

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
}
public extension Battlefield.Trait {
    static let obstacle = Self(
        name: "Obstacle",
        detailedDescription: "Blocks creature movement on battlefield."
    )
}
