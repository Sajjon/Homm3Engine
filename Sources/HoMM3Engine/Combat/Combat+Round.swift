//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-30.
//

import Foundation

public final class Round {
    
    public var actions = [Combat.Action]()
    public private(set) var waitingCreatureStacks = Stack<Combat.CreatureStack>()
    public private(set) var creaturesToAct: [Combat.CreatureStack]
    
    init(creaturesToAct: [Combat.CreatureStack]) {
        self.creaturesToAct = creaturesToAct
    }
    
}

public extension Round {
    
    typealias Turn = UInt
    
    func nextCreatureStackToAct() -> Combat.CreatureStack? {
        if let nextToAct = creaturesToAct.first {
            return nextToAct
        }
        if let waited =  waitingCreatureStacks.pop() {
            return waited
        }
        return nil
    }
    
    func append(action: Combat.Action) {
        actions.append(action)
    }
    
    var turn: Turn {
        .init(actions.count)
    }
}
