//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-25.
//

import XCTest
@testable import HoMM3Engine

final class SimpleCombatTests: XCTestCase {
    
    
    func testSimpleCombat() {
        let solmyr🔴 = Hero.solmyr(ownedBy: .red)
        let serena🔵 = Hero.serena(ownedBy: .blue)
        
        var blackDragons = BlackDragon.stack(of: 3, controlledBy: solmyr🔴)
        var redDragons = RedDragon.stack(of: 5, controlledBy: serena🔵)
        
        blackDragons.attack(&redDragons)
    }
}
