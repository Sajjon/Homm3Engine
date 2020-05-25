import Foundation

public protocol Trait: Modifier {
    
    /// A name which uniquely identifies this trait
    var uniqueName: CamelCasedStringAaZz { get }
    
    /// Only for display purposes
    var displayName: String { get }
    
    /// Detailed description of this trait
    var detailedDescription: String { get }
    
    func eraseToAnyTrait() -> AnyTrait
}

public extension Trait {
    func eraseToAnyTrait() -> AnyTrait {
        AnyTrait(trait: self)
    }
    
    var negatedBy: Set<AnyTrait> { Traits.negatedBy[self.eraseToAnyTrait()] ?? .empty }
    var negating: Set<AnyTrait> { Traits.negatingTraits[self.eraseToAnyTrait()] ?? .empty }

    func negating<T>(_ negatedTrait: T) -> Self where T: Trait  {
        Traits.mark(trait: negatedTrait, asNegatedBy: self)
        return self
    }
    
    func isNegated︖<T>(by possiblyNegatingTrait: T) -> Bool where T: Trait {
        negatedBy.contains(possiblyNegatingTrait.eraseToAnyTrait())
    }
    
    func isNegating︖<T>(_ possiblyNegatedTrait: T) -> Bool where T: Trait {
        negating.contains(possiblyNegatedTrait.eraseToAnyTrait())
    }
}

public protocol TraitInitializable: Trait {
    
    init(
        uniqueName: CamelCasedStringAaZz,
        displayName: String,
        detailedDescription: String
    )
}

public extension TraitInitializable {
    init(
        name: String,
        detailedDescription: String
    ) {
        self.init(
            uniqueName: .init(camelCasing: name),
            displayName: name,
            detailedDescription: detailedDescription
        )
    }
}

public func == <T, U>(lhs: T, rhs: U) -> Bool where T: Trait, U: Trait {
    lhs.uniqueName == rhs.uniqueName
}
