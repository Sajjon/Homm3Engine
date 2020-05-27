//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-27.
//

import Foundation

public protocol CombatModifying {
    func toCombatModifier() -> CombatModifier
}

/// NewType CombatModifier = Int, representing a combat modifier
public typealias CombatModifier = NewType<CombatModifierTag>

extension NewType: CombatModifying where Tag: CombatModifierBaseTag {
    public func toCombatModifier() -> CombatModifier {
        guard let combatMod = CombatModifier.init(exactly: self.rawValue) else {
            fatalError("should always be able to create CombatModifier from \(self) of type: \(type(of: self))")
        }
        return combatMod
    }
}
public extension CombatModifier {
    func toCombatModifier() -> CombatModifier {
        return self
     }
}

public protocol CombatModifierBaseTag: BaseTag where RawValue: Numeric & BinaryInteger & FixedWidthInteger {}
public final class CombatModifierTag: IntTagBase, CombatModifierBaseTag {}

public func + <LHS, RHS>(lhs: LHS, rhs: RHS) -> CombatModifier where LHS: CombatModifying, RHS: CombatModifying {
    lhs.toCombatModifier() + rhs.toCombatModifier()
}

public func - <LHS, RHS>(lhs: LHS, rhs: RHS) -> CombatModifier where LHS: CombatModifying, RHS: CombatModifying {
    lhs.toCombatModifier() - rhs.toCombatModifier()
}

public func * <LHS, RHS>(lhs: LHS, rhs: RHS) -> CombatModifier where LHS: CombatModifying, RHS: CombatModifying {
    lhs.toCombatModifier() * rhs.toCombatModifier()
}
