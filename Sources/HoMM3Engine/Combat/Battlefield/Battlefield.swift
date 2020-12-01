//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-25.
//

import Foundation


public struct Battlefield {
    public let size: Size
    public let terrain: Terrain
    public init(size: Size = .default, terrain: Terrain) {
        self.size = size
        self.terrain = terrain
    }
}

// MARK: Public
public extension Battlefield {
    
    typealias Index = UInt
    
    var indexOfLastTile: Index {
        indexOf(tile: lastTile)
    }
    
    func tile(at index: Index) -> HexTile {
        precondition(index <= indexOfLastTile)
        let (quotient, remainder) = index.quotientAndRemainder(dividingBy: Index(size.width))
        return HexTile(row: HexTile.Value(quotient), column: HexTile.Value(remainder))
    }
    
    /// tile.row*size.width + tile.column
    func indexOf(tile: HexTile) -> Index {
        UInt(tile.row * size.width) + UInt(tile.column)
    }
        
    var lastTile: HexTile {
        .init(row: size.height - 1, column: size.width - 1)
    }
}
