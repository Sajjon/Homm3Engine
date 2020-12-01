//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-29.
//

import Foundation

public extension Battlefield {
    struct Size: Equatable {
        public let width: HexTile.Value
        public let height: HexTile.Value
    }
}

public extension Battlefield.Size {
    static let `default` = Self(width: 15, height: 11)
}
