//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-27.
//

import Foundation

public struct Artifact: Modifier, Codable, Hashable, CustomStringConvertible {
    public let displayName: String
    public init(displayName: String) {
        self.displayName = displayName
    }
}
