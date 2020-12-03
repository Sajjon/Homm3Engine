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
    
    public init(
        size: Size = .default,
        terrain: Terrain = .grass
    ) {
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
    
    /// Calculates the euclidean distance between `source` and `destination` tiles on the battlefield.
    func distance(
        between source: HexTile,
        and destination: HexTile
    ) -> HexTile.Value {
        guard source != destination else { return 0 }
        
        let rowDelta = HexTile.Value(abs(destination.row - source.row))

        if source.column == destination.column {
            return rowDelta
        } else if source.row == destination.row {
            return HexTile.Value(abs(destination.column - source.column))
        } else {
            let rowOffset: HexTile.Value = source.row.sameParity(as: destination.row) ? 0 : 1
            let remainingColumnDeltaAfterDiagonal = HexTile.Value(floor(Double(rowDelta/2)))
            let columnsLeft = HexTile.Value(abs(destination.column - source.column - remainingColumnDeltaAfterDiagonal))
            let distance = rowDelta + columnsLeft
            return distance - rowOffset
        }
    }
}

public extension BinaryInteger { // :  where Self.Magnitude : BinaryInteger, Self.Magnitude == Self.Magnitude.Magnitude {
    var isEven: Bool {
        isMultiple(of: 2)
    }
    
    var isOdd: Bool {
        return !isEven
    }
    
    func sameParity(as other: Self) -> Bool {
        switch (self.isEven, other.isEven) {
        case (true, true): return true
        case (false, false): return true
        default: return false
        }
    }
}
