//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-30.
//

import Foundation

func implementMe(_ message: String? = nil) -> Never {
    fatalError("Implement me\(message.map { " \($0)" } ?? "")")
}

func propagate(error: Swift.Error, _ message: String? = nil) -> Never {
    fatalError("Propagate error: \(error)\(message.map { " \($0)" } ?? "")")
}
