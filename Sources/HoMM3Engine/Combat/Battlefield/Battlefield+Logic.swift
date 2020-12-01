//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-29.
//

import Foundation

public extension Battlefield {
    
    /// An example of a 3x3 battle field, where every other row is offsetted
    /// by half a tile in width, with half an empty hex tile, below denoted `_`
    ///
    /// _ t⁰ t¹ t²
    /// t³ t⁴ t⁵ _
    /// _ t⁶ t⁷ t⁸
    ///
    /// It is important to note that since the tiles are hex tiles, tiles that might would
    /// have been diagonally adjascent to one another if they where square shaped.
    func `is`(tile rhs: HexTile, adjecentTo lhs: HexTile) -> Bool {
        guard rhs != lhs else { return false }
        let rowDelta = abs(Int(rhs.row) - Int(lhs.row))
        let columnDelta = abs(Int(rhs.column) - Int(lhs.column))
        if columnDelta <= 1 && rowDelta <= 1 { return true }
        return false
    }
    
}
