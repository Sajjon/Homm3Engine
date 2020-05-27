//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-27.
//

import Foundation
import GameplayKit

public final class SeededGenerator: RandomNumberGenerator {
    
    public let seed: Seed
    private let generator: GKMersenneTwisterRandomSource
    
    public init(seed: Seed = .random(in: Seed.min ... Seed.max)) {
        self.seed = seed
        self.generator = GKMersenneTwisterRandomSource(seed: seed)
    }
  
}

public extension SeededGenerator {
    typealias Seed = UInt64
}

// MARK: RandomNumberGenerator
public extension SeededGenerator {
    
    func next<T>(upperBound: T) -> T where T: FixedWidthInteger & UnsignedInteger {
        T(abs(generator.nextInt(upperBound: Int(upperBound))))
    }
    
    func next<T>() -> T where T: FixedWidthInteger & UnsignedInteger {
        T(abs(generator.nextInt()))
    }
}
