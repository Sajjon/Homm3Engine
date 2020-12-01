//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-27.
//

import Foundation

// MARK: Defense
public typealias Defense = NewType<DefenseTag>
public final class DefenseTag: UIntTagBase, CombatModifierBaseTag {}
