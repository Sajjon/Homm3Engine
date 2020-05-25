//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-25.
//

import Foundation

func - <I>(lhs: I, rhs: I?) -> I where I: FixedWidthInteger {
    guard let substractor = rhs else { return lhs }
    let (result, didOverflow) = lhs.subtractingReportingOverflow(substractor)
    assert(!didOverflow)
    return result
}

extension Optional where Wrapped: FixedWidthInteger {
    static func += (optional: inout Self, increment: Wrapped) {
        switch optional {
        case .none: optional = .some(increment)
        case .some(let unwrapped): optional = .some(unwrapped + increment)
        }
    }
}
