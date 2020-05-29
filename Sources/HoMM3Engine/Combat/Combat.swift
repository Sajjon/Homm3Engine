//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-27.
//

import Foundation

public final class Army: CustomStringConvertible {
    
    public let hero: Hero?
    public private(set) var creatureStacks: [Creature.Stack]
    
    private init(
        hero: Hero?,
        creatureStacks: [Creature.Stack]
    ) {
        self.hero = hero
        self.creatureStacks = creatureStacks
//        self.creatureStacks.forEach {
//            ifHaveHero(takeControlOf: $0)
//        }
    }
    
}

public extension Army {
    
    typealias SelfC = Army
    
    convenience init(
        creatureStacks: [Creature.Stack]
    ) {
        self.init(hero: nil, creatureStacks: creatureStacks)
    }
    
    convenience init(
        hero: Hero
    ) {
        self.init(hero: hero, creatureStacks: [])
    }
}

extension Optional {
    mutating func assertNilAndAssign(optional: Wrapped?) {
        guard self == nil else {
            fatalError("Expected optional to be nil before setting it.")
        }
        self = optional
    }
}

public extension Creature {
    struct Stack {
        public typealias Quantity = UInt
        
        public let quantity: Quantity
        public let creatureType: Creature
        
    }
    
    func stack(of quantity: Stack.Quantity) -> Stack {
        .init(quantity: quantity, creatureType: self)
    }
}

//private extension Army {
//    func ifHaveHero(takeControlOf creatureStack: CreatureStack) {
//        defer {  creatureStack.controllingHero.assertNilAndAssign(optional: hero) }
//        guard let hero = hero else {
//            return
//        }
//        if let heroOfStack = creatureStack.controllingHero {
//            assert(heroOfStack === hero)
//        }
//
//    }
//}

public extension Army {
    
    @discardableResult
    func add(creatureStack: Creature.Stack) -> SelfC {
        creatureStacks.append(creatureStack)
//        ifHaveHero(takeControlOf: creatureStack)
        return self
    }
    
}

public extension Army {
    var description: String {
        if let hero = hero {
            return "\(hero) \(creatureStacks) "
        } else {
            return String(describing: creatureStacks)
        }
    }
}

extension Combat.CreatureStack {
    public typealias Tag = NewType<CreatureStackTagTag>
    public final class CreatureStackTagTag: UIntTagBase {}
}

public extension Combat {
    struct CreatureStackTagMapping: ExpressibleByDictionaryLiteral {
        public typealias Tag = Combat.CreatureStack.Tag
        public typealias Key = Tag
        public typealias Value = Combat.CreatureStack
        
        public let tagToStack: [Combat.CreatureStack.Tag: Combat.CreatureStack]
        
        public init(map: [Combat.CreatureStack.Tag: Combat.CreatureStack]) {
            self.tagToStack = map
        }
        
        public init(dictionaryLiteral elements: (Self.Key, Self.Value)...) {
            self.init(map: .init(uniqueKeysWithValues: elements))
        }
    }
}

public final class Encounter {
    
    public unowned let attacker: Army
     public unowned let defender: Army
     public let battleField: Battlefield
     
     public init(betweenAttacker attacker: Army, defender: Army, on battleField: Battlefield) {
         self.attacker = attacker
         self.defender = defender
         self.battleField = battleField
     }

    
    func startCombat(
        _ tagCreatureStacks: (_ attacker: Combat.FightingArmy, _ defender: Combat.FightingArmy) -> Combat.CreatureStackTagMapping,
        _ playCombat: (Combat) throws -> Combat.LoserOutcome
    ) rethrows -> Combat.Report {
        
        let combat = Combat(battleField: battleField)
        
        func mapS(_ creatureStack: Creature.Stack, stackIndex: Int, isAttacker: Bool) -> Combat.CreatureStack {

            func assignStackTile() -> Battlefield.HexTile {
                .init(row: Battlefield.HexTile.Value(stackIndex), column: isAttacker ? 0 : battleField.size.width)
            }
            
            let army = isAttacker ? self.attacker : self.defender
            
            return Combat.CreatureStack(
                creatureStack.quantity,
                type: creatureStack.creatureType,
                army: army,
                combat: combat,
                tile: assignStackTile()
            )
        }
        
        let aggressor = Combat.FightingArmy(
            hero: attacker.hero,
            creatureStacks: attacker.creatureStacks.enumerated().map { mapS($0.element, stackIndex: $0.offset, isAttacker: true) }
        )
        
        let victim = Combat.FightingArmy(
            hero: defender.hero,
            creatureStacks: defender.creatureStacks.enumerated().map { mapS($0.element, stackIndex: $0.offset, isAttacker: false) }
        )
        
        combat.attacker = aggressor
        combat.defender = victim
        
        combat.tagToStackMap = tagCreatureStacks(aggressor, victim)
        
        let outcome = try playCombat(combat)
        
        return Combat.Report(winner: attacker, loserOutcome: outcome)
    }
}


public final class Combat: CustomStringConvertible {
    
    public func stack(tag: Combat.CreatureStackTagMapping.Tag/*, in army: FightingArmy*/) -> Combat.CreatureStack {
        guard
            let mapping = tagToStackMap?.tagToStack,
            let stack = mapping[tag]
        else { fatalError("no mapping or stack for tag") }
        return stack
    }
    
//    public func agressorStack(_ tag: Combat.CreatureStackTagMapping.Tag) -> Combat.CreatureStack {
//        creatureStack(tag, in: attacker)
//    }
//
//    public func victimStack(_ tag: Combat.CreatureStackTagMapping.Tag) -> Combat.CreatureStack {
//        creatureStack(tag, in: defender)
//
//    }
    
    public final class FightingArmy {
        
        public let hero: Hero?
        public private(set) var creatureStacks: [Combat.CreatureStack]
        
        public init(
            hero: Hero?,
            creatureStacks: [Combat.CreatureStack]
        ) {
            self.hero = hero
            self.creatureStacks = creatureStacks
        }
        
    }

    
    public fileprivate(set) var attacker: FightingArmy!
    public fileprivate(set) var defender: FightingArmy!
    fileprivate var tagToStackMap: CreatureStackTagMapping!
    public let battleField: Battlefield
    
    fileprivate init(battleField: Battlefield) {
        self.battleField = battleField
    }

    public private(set) var report: Report?
}

public extension Combat {
    
    enum Action {
        public struct StackAttack {
            public let targetStack: CreatureStack
            public let attackType: AttackType
            public init(_ targetStack: CreatureStack, type attackType: AttackType = .melee) {
                self.targetStack = targetStack
                self.attackType = attackType
            }
        }
        case move(stack: CreatureStack, to: Battlefield.HexTile, attack: StackAttack? = nil)
        case attack(StackAttack)
        case defend(CreatureStack), wait(CreatureStack)
    }
    
    var description: String {
        "\(attacker!) vs \(defender!) "
    }
    
    var isFinished: Bool { report != nil }
}

public extension Combat {
    
    func autoPlay(randomness: RandomnessSource = .init(behaviour: .deterministic())) -> Report {
        fatalError()
    }
    
    func perform(action: Action) throws {
        switch action {
        case .defend(let stack): "\(stack) defends"
        case .wait(let stack): "\(stack) waits"
        case .move(let stack, let destinationTile, let possibleAttack):
            try move(stack: stack, to: destinationTile)
            guard let attack = possibleAttack else {
                return
            }
            
        }
    }
    
    private func move(stack: CreatureStack, to destinationTile: Battlefield.HexTile) throws {
        guard stack.positionOnBattleField != destinationTile else {
            throw ActionError.ActionError
        }
        
    }
    
    enum ActionError: Swift.Error, Equatable {
        case invalidMoveAlreadyOnTile
    }
}

public extension Combat {
    struct Report {
        public unowned let winner: Army
        
        public let loserOutcome: LoserOutcome
        
    }
    
    enum LoserOutcome: String, Hashable, Codable, CustomStringConvertible {
         case surrendered
         case retreated
         case slaughtered
     }
}
