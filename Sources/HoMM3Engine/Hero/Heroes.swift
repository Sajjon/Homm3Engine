//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-26.
//

import Foundation

public extension Hero {
    
    static func solmyr(ownedBy player: Player) -> Self {
        .init(
            trivia: Hero.Trivia(
                name: "Solmyr",
                heroClass: .wizard,
                gender: .male,
                race: .genie,
                biography: "Solmyr was trapped in a genie bottle for over a millenium, and was so grateful to the human who finally released him that he swore to serve the man for the rest of his life. As fate would have it, that man is Gavin Magnus, the immortal ruler of the Bracada Highlands."
            ),
            
            owner: player,
            specialty: .spell(.chainLightning),
            secondarySkills: [.basic(.wisdom), .basic(.sourcery)],
            spellBook: [.chainLightning]
        )
    }
    
static func serena(ownedBy player: Player) -> Self {
     .init(
         trivia: Hero.Trivia(
             name: "Serena",
             heroClass: .wizard,
             gender: .female,
             race: .genie,
             biography: "Serena nearly killed herself the first time she cast a spell. She channeled so much magical energy into the spell that a Wizard in a neighboring town felt it. He quickly sought her out, bringing her to the Wizards' Guild so that she could learn to control her powers."
         ),
         
         owner: player,
         specialty: .secondarySkill(.eagleEye),
         secondarySkills: [.basic(.wisdom), .basic(.eagleEye)],
         spellBook: [.dispel]
     )
 }

}
