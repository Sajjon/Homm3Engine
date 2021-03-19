//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-29.
//

import Foundation

public extension Battlefield {
    struct HexTile: Comparable, Hashable {
        public let row: HexTile.Value
        public let column: HexTile.Value
    }
}

// MARK: Comparable
public extension Battlefield.HexTile {
    static func < (lhs: Self, rhs: Self) -> Bool {
        guard lhs.row < rhs.row else { return false }
        return lhs.column < rhs.column
    }
}

// MARK: Value
public extension Battlefield.HexTile {
    typealias Value = NewType<HexTileTag>
    final class HexTileTag: IntTagBase {}
}

// MARK: Public
public extension Battlefield.HexTile {
    var name: String {
        return "r\(String(row.rawValue, radix: 16))c\(String(column.rawValue, radix: 16))"
    }
}

extension Battlefield.HexTile.Value: ExpressibleByUnicodeScalarLiteral {
    public typealias UnicodeScalarLiteralType = StringLiteralType
}
extension Battlefield.HexTile.Value: ExpressibleByExtendedGraphemeClusterLiteral {
    public typealias ExtendedGraphemeClusterLiteralType = UnicodeScalarLiteralType
}
extension Battlefield.HexTile.Value: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    public init(stringLiteral hexString: StringLiteralType) {
        guard let fromHex = Self(hexString, radix: 16) else {
            fatalError("bad literal: \(hexString)")
        }
        self = fromHex
    }
}


// MARK: Named
public extension Battlefield.HexTile {
    
    // MARK: Row 0
    static let r0c0 = Self(row: 0, column: 0)
    static let r0c1 = Self(row: 0, column: 1)
    static let r0c2 = Self(row: 0, column: 2)
    static let r0c3 = Self(row: 0, column: 3)
    static let r0c4 = Self(row: 0, column: 4)
    static let r0c5 = Self(row: 0, column: 5)
    static let r0c6 = Self(row: 0, column: 6)
    static let r0c7 = Self(row: 0, column: 7)
    static let r0c8 = Self(row: 0, column: 8)
    static let r0c9 = Self(row: 0, column: 9)
    static let r0cA = Self(row: 0, column: "A")
    static let r0cB = Self(row: 0, column: "B")
    static let r0cC = Self(row: 0, column: "C")
    static let r0cD = Self(row: 0, column: "D")
    static let r0cE = Self(row: 0, column: "E")
    
    // MARK: Row 1
    static let r1c0 = Self(row: 1, column: 0)
    static let r1c1 = Self(row: 1, column: 1)
    static let r1c2 = Self(row: 1, column: 2)
    static let r1c3 = Self(row: 1, column: 3)
    static let r1c4 = Self(row: 1, column: 4)
    static let r1c5 = Self(row: 1, column: 5)
    static let r1c6 = Self(row: 1, column: 6)
    static let r1c7 = Self(row: 1, column: 7)
    static let r1c8 = Self(row: 1, column: 8)
    static let r1c9 = Self(row: 1, column: 9)
    static let r1cA = Self(row: 1, column: "A")
    static let r1cB = Self(row: 1, column: "B")
    static let r1cC = Self(row: 1, column: "C")
    static let r1cD = Self(row: 1, column: "D")
    static let r1cE = Self(row: 1, column: "E")
    
    // MARK: Row 2
    static let r2c0 = Self(row: 2, column: 0)
    static let r2c1 = Self(row: 2, column: 1)
    static let r2c2 = Self(row: 2, column: 2)
    static let r2c3 = Self(row: 2, column: 3)
    static let r2c4 = Self(row: 2, column: 4)
    static let r2c5 = Self(row: 2, column: 5)
    static let r2c6 = Self(row: 2, column: 6)
    static let r2c7 = Self(row: 2, column: 7)
    static let r2c8 = Self(row: 2, column: 8)
    static let r2c9 = Self(row: 2, column: 9)
    static let r2cA = Self(row: 2, column: "A")
    static let r2cB = Self(row: 2, column: "B")
    static let r2cC = Self(row: 2, column: "C")
    static let r2cD = Self(row: 2, column: "D")
    static let r2cE = Self(row: 2, column: "E")
    
    
    // MARK: Row 3
    static let r3c0 = Self(row: 3, column: 0)
    static let r3c1 = Self(row: 3, column: 1)
    static let r3c2 = Self(row: 3, column: 2)
    static let r3c3 = Self(row: 3, column: 3)
    static let r3c4 = Self(row: 3, column: 4)
    static let r3c5 = Self(row: 3, column: 5)
    static let r3c6 = Self(row: 3, column: 6)
    static let r3c7 = Self(row: 3, column: 7)
    static let r3c8 = Self(row: 3, column: 8)
    static let r3c9 = Self(row: 3, column: 9)
    static let r3cA = Self(row: 3, column: "A")
    static let r3cB = Self(row: 3, column: "B")
    static let r3cC = Self(row: 3, column: "C")
    static let r3cD = Self(row: 3, column: "D")
    static let r3cE = Self(row: 3, column: "E")
    
    
    // MARK: Row 4
    static let r4c0 = Self(row: 4, column: 0)
    static let r4c1 = Self(row: 4, column: 1)
    static let r4c2 = Self(row: 4, column: 2)
    static let r4c3 = Self(row: 4, column: 3)
    static let r4c4 = Self(row: 4, column: 4)
    static let r4c5 = Self(row: 4, column: 5)
    static let r4c6 = Self(row: 4, column: 6)
    static let r4c7 = Self(row: 4, column: 7)
    static let r4c8 = Self(row: 4, column: 8)
    static let r4c9 = Self(row: 4, column: 9)
    static let r4cA = Self(row: 4, column: "A")
    static let r4cB = Self(row: 4, column: "B")
    static let r4cC = Self(row: 4, column: "C")
    static let r4cD = Self(row: 4, column: "D")
    static let r4cE = Self(row: 4, column: "E")
    
    // MARK: Row 5
    static let r5c0 = Self(row: 5, column: 0)
    static let r5c1 = Self(row: 5, column: 1)
    static let r5c2 = Self(row: 5, column: 2)
    static let r5c3 = Self(row: 5, column: 3)
    static let r5c4 = Self(row: 5, column: 4)
    static let r5c5 = Self(row: 5, column: 5)
    static let r5c6 = Self(row: 5, column: 6)
    static let r5c7 = Self(row: 5, column: 7)
    static let r5c8 = Self(row: 5, column: 8)
    static let r5c9 = Self(row: 5, column: 9)
    static let r5cA = Self(row: 5, column: "A")
    static let r5cB = Self(row: 5, column: "B")
    static let r5cC = Self(row: 5, column: "C")
    static let r5cD = Self(row: 5, column: "D")
    static let r5cE = Self(row: 5, column: "E")
    
    // MARK: Row 6
    static let r6c0 = Self(row: 6, column: 0)
    static let r6c1 = Self(row: 6, column: 1)
    static let r6c2 = Self(row: 6, column: 2)
    static let r6c3 = Self(row: 6, column: 3)
    static let r6c4 = Self(row: 6, column: 4)
    static let r6c5 = Self(row: 6, column: 5)
    static let r6c6 = Self(row: 6, column: 6)
    static let r6c7 = Self(row: 6, column: 7)
    static let r6c8 = Self(row: 6, column: 8)
    static let r6c9 = Self(row: 6, column: 9)
    static let r6cA = Self(row: 6, column: "A")
    static let r6cB = Self(row: 6, column: "B")
    static let r6cC = Self(row: 6, column: "C")
    static let r6cD = Self(row: 6, column: "D")
    static let r6cE = Self(row: 6, column: "E")
    
    // MARK: Row 7
    static let r7c0 = Self(row: 7, column: 0)
    static let r7c1 = Self(row: 7, column: 1)
    static let r7c2 = Self(row: 7, column: 2)
    static let r7c3 = Self(row: 7, column: 3)
    static let r7c4 = Self(row: 7, column: 4)
    static let r7c5 = Self(row: 7, column: 5)
    static let r7c6 = Self(row: 7, column: 6)
    static let r7c7 = Self(row: 7, column: 7)
    static let r7c8 = Self(row: 7, column: 8)
    static let r7c9 = Self(row: 7, column: 9)
    static let r7cA = Self(row: 7, column: "A")
    static let r7cB = Self(row: 7, column: "B")
    static let r7cC = Self(row: 7, column: "C")
    static let r7cD = Self(row: 7, column: "D")
    static let r7cE = Self(row: 7, column: "E")

    // MARK: Row 8
    static let r8c0 = Self(row: 8, column: 0)
    static let r8c1 = Self(row: 8, column: 1)
    static let r8c2 = Self(row: 8, column: 2)
    static let r8c3 = Self(row: 8, column: 3)
    static let r8c4 = Self(row: 8, column: 4)
    static let r8c5 = Self(row: 8, column: 5)
    static let r8c6 = Self(row: 8, column: 6)
    static let r8c7 = Self(row: 8, column: 7)
    static let r8c8 = Self(row: 8, column: 8)
    static let r8c9 = Self(row: 8, column: 9)
    static let r8cA = Self(row: 8, column: "A")
    static let r8cB = Self(row: 8, column: "B")
    static let r8cC = Self(row: 8, column: "C")
    static let r8cD = Self(row: 8, column: "D")
    static let r8cE = Self(row: 8, column: "E")
    
    // MARK: Row 9
    static let r9c0 = Self(row: 9, column: 0)
    static let r9c1 = Self(row: 9, column: 1)
    static let r9c2 = Self(row: 9, column: 2)
    static let r9c3 = Self(row: 9, column: 3)
    static let r9c4 = Self(row: 9, column: 4)
    static let r9c5 = Self(row: 9, column: 5)
    static let r9c6 = Self(row: 9, column: 6)
    static let r9c7 = Self(row: 9, column: 7)
    static let r9c8 = Self(row: 9, column: 8)
    static let r9c9 = Self(row: 9, column: 9)
    static let r9cA = Self(row: 9, column: "A")
    static let r9cB = Self(row: 9, column: "B")
    static let r9cC = Self(row: 9, column: "C")
    static let r9cD = Self(row: 9, column: "D")
    static let r9cE = Self(row: 9, column: "E")
    
    // MARK: Row A (10(
    static let rAc0 = Self(row: "A", column: 0)
    static let rAc1 = Self(row: "A", column: 1)
    static let rAc2 = Self(row: "A", column: 2)
    static let rAc3 = Self(row: "A", column: 3)
    static let rAc4 = Self(row: "A", column: 4)
    static let rAc5 = Self(row: "A", column: 5)
    static let rAc6 = Self(row: "A", column: 6)
    static let rAc7 = Self(row: "A", column: 7)
    static let rAc8 = Self(row: "A", column: 8)
    static let rAc9 = Self(row: "A", column: 9)
    static let rAcA = Self(row: "A", column: "A")
    static let rAcB = Self(row: "A", column: "B")
    static let rAcC = Self(row: "A", column: "C")
    static let rAcD = Self(row: "A", column: "D")
    static let rAcE = Self(row: "A", column: "E")
}


