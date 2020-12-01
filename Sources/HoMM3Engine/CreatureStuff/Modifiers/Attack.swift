//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-27.
//

import Foundation

// MARK: Attack
public typealias Attack = NewType<AttackTag>
public final class AttackTag: UIntTagBase, CombatModifierBaseTag {}
