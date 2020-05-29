//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-27.
//

import Foundation
import GameplayKit

public final class RandomnessSource: RandomNumberGenerator {
    
    public let behaviour: Behaviour
    private var randomNumberGenerator: RandomNumberGenerator
    
    public init(behaviour: Behaviour = .pseudoRandom) {
        self.behaviour = behaviour
        switch behaviour {
        case .deterministic(let seed):
            self.randomNumberGenerator = SeededRandomGenerator(seed: seed)
        case .pseudoRandom:
            self.randomNumberGenerator = SystemRandomNumberGenerator()
        }
    }
}

public extension RandomnessSource {
    typealias Seed = UInt64
    enum Behaviour {
        case deterministic(seed: Seed = .random(in: Seed.min ... Seed.max))
        case pseudoRandom
    }
}

// MARK: RandomNumberGenerator
public extension RandomnessSource {
    
    func next<T>(upperBound: T) -> T where T: FixedWidthInteger & UnsignedInteger {
        randomNumberGenerator.next(upperBound: upperBound)
    }
    
    func next<T>() -> T where T: FixedWidthInteger & UnsignedInteger {
        randomNumberGenerator.next()
    }
}

// MARK: SeededRandomGenerator
private final class SeededRandomGenerator: RandomNumberGenerator {
    typealias Seed = RandomnessSource.Seed
    private let seed: Seed
    private let generator: GKMersenneTwisterRandomSource
    
    init(seed: Seed = .random(in: Seed.min ... Seed.max)) {
        self.seed = seed
        self.generator = GKMersenneTwisterRandomSource(seed: seed)
    }
}

// MARK: RandomNumberGenerator
private extension SeededRandomGenerator {
    
    func next<T>(upperBound: T) -> T where T: FixedWidthInteger & UnsignedInteger {
        T(abs(generator.nextInt(upperBound: Int(upperBound))))
    }
    
    func next<T>() -> T where T: FixedWidthInteger & UnsignedInteger {
        T(abs(generator.nextInt()))
    }
}
