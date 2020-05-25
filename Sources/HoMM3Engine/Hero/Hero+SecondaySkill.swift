//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-26.
//

import Foundation

public extension Hero {
//    func has(_ level: SecondarySkillLevel, of skillType: SecondarySkillType) -> Bool {
//        secondarySkills.contains(.init(type: skillType, level: level))
//    }
    
    func level(of skillType: SecondarySkillType) -> SecondarySkillLevel? {
        secondarySkills.first(where: { $0.skillType == skillType })?.skillLevel
    }
}
