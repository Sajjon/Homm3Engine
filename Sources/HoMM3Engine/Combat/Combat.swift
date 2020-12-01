//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-27.
//

import Foundation


public final class Combat: CustomStringConvertible {
    
    public private(set) var isFinished = false
    
    private var rounds: [Round] = []
    private var currentRound: Round { rounds.last! }
    
    public let battlefield: Battlefield
    private let aggressor: FightingArmy
    private let protector: FightingArmy
    
    public init(
        battlefield: Battlefield,
        attackingArmy: Army,
        defendingArmy: Army
    ) {
        self.battlefield = battlefield
        
        self.aggressor = .init(
            army: attackingArmy,
            battlefield: battlefield,
            isAttackingArmy: true
        )
        
        self.protector = .init(
            army: defendingArmy,
            battlefield: battlefield,
            isAttackingArmy: false
        )
        
        prepareNextRound()
    }
}

public extension Combat {
    var description: String {
        "\(aggressor) vs \(protector) "
    }
}


public extension Combat {
    
    final class TileContent {
        /// Might be empty, only allowed to contain one alive stack, might contain dead stacks on index 1, 2...
        public let creatureStacks: [CreatureStack]
        public var aliveCreatureStack: CreatureStack? {
            guard let alive = creatureStacks.first else {
                return nil
            }
            assert(alive.isAlive)
            return alive
        }
        public let tile: Battlefield.HexTile
        public init(tile: Battlefield.HexTile, creatureStacks: [CreatureStack] = []) {
            self.tile = tile
            self.creatureStacks = creatureStacks
        }
    }
    
    var tiles: [TileContent] {
        let allCreatures: [CreatureStack] = [aggressor.creatureStacks, protector.creatureStacks].flatMap { $0 }
        let creaturesSortedByTiles = allCreatures.sorted(by: \.positionOnBattleField, order: .ascending)
        let creatureOnTiles = [Battlefield.HexTile: [CreatureStack]].init(grouping: creaturesSortedByTiles, by: { $0.positionOnBattleField })
        var tiles = [TileContent]()
        for tileIndex in 0...battlefield.indexOfLastTile {
            let tile = battlefield.tile(at: tileIndex)
            tiles.append(TileContent(tile: tile, creatureStacks: creatureOnTiles[tile] ?? []))
        }
        return tiles
    }
    
    //    func progress(
    //        _ act: (_ firstStackToAct: Combat.CreatureStack) throws -> Combat.Action
    //    ) rethrows -> Combat.Result? {
    //
    //        var outcome: Combat.Result.LoserOutcome = .slaughtered
    //
    //        combatLoop: while let stack = nextCreatureStackToAct() {
    //            do {
    //                let action = try act(stack)
    //
    //                switch action {
    //                case .creatureStackAction(let creatureStackAction):
    //                    try creatureStack(stack, performsAction: creatureStackAction)
    //                case .heroAction(let heroAction):
    //                    switch heroAction {
    //                    case .castSpell(let spell, let target):
    //                        try castSpell(spell, on: target)
    //                    case .retreat:
    //                        outcome = retreat()
    //                        break combatLoop
    //                    case .surrender:
    //                        outcome = surrender()
    //                        break combatLoop
    //                    }
    //                }
    //            } catch {
    //                propagate(error: error)
    //            }
    //        }
    //
    //        let winningArmy = getWinner()
    //        let losingArmy = getLoser()
    //
    //        return Combat.Result(
    //            winner: .init(
    //                hero: winningArmy.hero?.awardExperiencePoints(xpGainedByWinner()),
    //                creatureStacks: winningArmy.survivingCreatureStacks()
    //            ),
    //            losingArmy: .init(
    //                hero: losingArmy.hero,
    //                creatureStacks: losingArmy.survivingCreatureStacks()
    //            ),
    //            loserOutcome: outcome
    //        )
    //    }
    
    func progress(
        _ act: (_ firstStackToAct: Combat.CreatureStack, _ round: Round) throws -> Combat.Action
    ) rethrows -> Combat.Result? {
        return nil
    }
}

public extension Array {
    enum Order: Int, Equatable {
        case ascending
        case descending
    }
    func sorted<Property>(
        by keyPath: KeyPath<Element, Property>,
        order: Order
    ) -> [Element] where Property: Comparable {
        sorted { (lhs, rhs) -> Bool in
            let lhsProperty = lhs[keyPath: keyPath]
            let rhsProperty = rhs[keyPath: keyPath]
            switch order {
            case .ascending: return lhsProperty > rhsProperty
            case .descending: return  lhsProperty < rhsProperty
            }
        }
    }
}

private extension Combat {
    
    /// Performs an action for the current stack, then returns the next stack to act, if combat is not over
    func creatureStack(_ stack: CreatureStack, performsAction action: CreatureStackAction) throws {
        switch action {
        case .defend:
            implementMe("\(stack) defends")
        case .wait:
            implementMe("\(stack) waits")
        case .move(let destinationTile, let possibleTiledAttacked):
            try performMove(by: stack, to: destinationTile)
            guard let tiledAttacked = possibleTiledAttacked else {
                return
            }
            try performAttack(by: stack, onTile: tiledAttacked)
        case .attackTile(let tiledAttacked):
            try performAttack(by: stack, onTile: tiledAttacked)
        }
    }
    
    @discardableResult
    func prepareNextRound() -> Round {
        let round = Round(
            creaturesToAct:
            [aggressor, protector]
                .flatMap({ $0.creatureStacks })
                .filter({ $0.isAlive })
                .sorted(by: \.initiative, order: .descending)
        )
        rounds.append(round)
        return round
    }
    
    func getWinner() -> FightingArmy {
        implementMe()
    }
    
    func getLoser() -> FightingArmy {
        implementMe()
    }
    
    func nextCreatureStackToAct() -> CreatureStack? {
        if let nextToAct = currentRound.nextCreatureStackToAct() {
            return nextToAct
        }
        let nextRound = prepareNextRound()
        return nextRound.nextCreatureStackToAct()
    }
    
    func xpGainedByWinner() -> Hero.ExperiencePoints {
        implementMe()
    }
    
    func performMove(by stack: CreatureStack, to destinationTile: Battlefield.HexTile) throws {
        guard stack.positionOnBattleField != destinationTile else {
            throw Action.Error.invalidMoveAlreadyOnTile
        }
        // Check teleport/flying/obstacles/creatures blocking/castle wall/ speed (range)
    }
    
    func performAttack(by stack: CreatureStack, onTile tileAttacked: Battlefield.HexTile) throws {
        implementMe("Attack")
    }
    
    func castSpell(_ spell: Spell, on targetCreatureStack: Combat.CreatureStack) throws {
        implementMe("cast spell")
    }
    
    func surrender() -> Combat.Result.LoserOutcome {
        return .surrendered
    }
    
    func retreat() -> Combat.Result.LoserOutcome {
        return .retreated
    }
}

private extension Combat.FightingArmy {
    func survivingCreatureStacks() -> [Creature.Stack] {
        fatalError()
    }
}
