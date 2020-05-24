import Foundation

public protocol Trait {
    
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
}


public func == <T, U>(lhs: T, rhs: U) -> Bool where T: Trait, U: Trait {
    lhs.uniqueName == rhs.uniqueName
}
