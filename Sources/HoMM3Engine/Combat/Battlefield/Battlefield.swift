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
        between hex1: HexTile,
        and hex2: HexTile
    ) -> HexTile.Value {
        if hex1 == hex2 { return 0 }
        
        let y1 = hex1.y
        let y2 = hex2.y
        let x1 = HexTile.Value(Double(hex1.x + y1) / 2)
        let x2 = HexTile.Value(Double(hex2.x + y2) / 2)
        
        let xDst = x2 - x1
        let yDst = y2 - y1
        
        let tmpDist: HexTile.Value
        
        if (xDst >= 0 && yDst >= 0) || (xDst < 0 && yDst < 0) {
            tmpDist = max(
                abs(xDst),
                abs(yDst)
            )
        } else {
            tmpDist = abs(xDst) + abs(yDst)
        }
        
        return max(1, tmpDist)
    }
}

private extension Battlefield.HexTile {
    var y: Value {
        row
    }
    
    var x: Value {
        column
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
