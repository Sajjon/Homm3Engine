//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-26.
//

import Foundation

public extension Hero {
    
    private static func ofClass(
        _ heroClass: HeroClass,
        player: Player,
        name: String = #function
    ) -> Self {
        .init(name: name, owner: player, heroClass: heroClass)
    }
    
    static func solmyr(ownedBy player: Player) -> Self {
        .ofClass(.wizard, player: player)
    }
    
    static func serena(ownedBy player: Player) -> Self {
        .ofClass(.wizard, player: player)
    }
    
    static func cragHag(ownedBy player: Player) -> Self {
        .ofClass(.barbarian, player: player)
    }
    
    static func gundula(ownedBy player: Player) -> Self {
        .ofClass(.battleMage, player: player)
    }
    
    static func orrin(ownedBy player: Player) -> Self {
        .ofClass(.knight, player: player)
    }
}
