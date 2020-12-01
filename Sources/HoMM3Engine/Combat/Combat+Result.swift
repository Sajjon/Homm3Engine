//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-29.
//

import Foundation

public extension Combat {
    struct Result {
        public let winner: Army
        public let losingArmy: Army?
        public let loserOutcome: LoserOutcome
    }
}

public extension Combat.Result {
    enum LoserOutcome: String, Hashable, Codable, CustomStringConvertible {
         case surrendered
         case retreated
         case slaughtered
     }
}
