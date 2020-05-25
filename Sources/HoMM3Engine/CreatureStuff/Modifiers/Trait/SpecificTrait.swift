//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-25.
//

import Foundation

public protocol SpecificTrait: Trait {
    associatedtype SpecificContent
    var description: AnyTrait { get }
}

public extension SpecificTrait {
    var uniqueName: CamelCasedStringAaZz { description.uniqueName }
    var displayName: String { description.displayName }
    var detailedDescription: String { description.detailedDescription }
}
