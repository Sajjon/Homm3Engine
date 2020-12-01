//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-29.
//

import Foundation

public extension Combat {
    enum Action {
        case heroAction(Hero)
        case creatureStackAction(CreatureStack)
    }
    typealias HeroAction = Action.Hero
    typealias CreatureStackAction = Action.CreatureStack
}

public extension Combat.Action {
    enum Error: Swift.Error, Equatable {
        case invalidMoveAlreadyOnTile
    }
    
    enum Hero {
        case castSpell(Spell, on: Combat.CreatureStack)
        case retreat, surrender
    }
    
    enum CreatureStack {
        case move(to: Battlefield.HexTile, attackOnTile: Battlefield.HexTile? = nil)
        
        case attackTile(Battlefield.HexTile)
        case defend
        case wait
    }
}

