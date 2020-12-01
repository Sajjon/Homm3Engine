//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-29.
//

import Foundation

public extension Combat {
    final class FightingArmy: CustomStringConvertible {
        
        public let hero: Hero?
        public private(set) var creatureStacks: [Combat.CreatureStack] = .init()
        
        public init(
            army: Army,
            battlefield: Battlefield,
            isAttackingArmy: Bool
        ) {
            
            self.hero = army.hero
            
            func addStackToArmy(_ indexAndElement: (offset: Int, element: Creature.Stack)) -> Combat.CreatureStack {
                let creatureStack = indexAndElement.element
                let stackIndex = indexAndElement.offset
                
                func assignStackTile() -> Battlefield.HexTile {
                    .init(row: Battlefield.HexTile.Value(stackIndex), column: isAttackingArmy ? 0 : battlefield.size.width-1)
                }
                return Combat.CreatureStack(
                    creatureStack.quantity,
                    type: creatureStack.creatureType,
                    fightingInArmy: self,
                    tile: assignStackTile()
                )
            }
            
            self.creatureStacks = army.creatureStacks.enumerated().map(addStackToArmy)
    
        }
    }
}

public extension Combat.FightingArmy {
    var description: String {
        let heroDescriptionIfAny = hero.mapSome { ", hero: \($0)" }
        return "#\(creatureStacks.count) stacks\(heroDescriptionIfAny)"
    }
}

public extension Optional {
    func mapSome<Mapped>(defaultValue: Mapped, _ mapIfPresent: (Wrapped) -> Mapped) -> Mapped {
        guard let value = self else {
            return defaultValue
        }
        return mapIfPresent(value)
    }
    
    func mapSome(_ mapIfPresent: @escaping (Wrapped) -> String) -> String {
        mapSome(defaultValue: "", mapIfPresent)
    }
}
