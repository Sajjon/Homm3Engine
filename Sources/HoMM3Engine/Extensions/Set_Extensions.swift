//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-24.
//

import Foundation

extension Set {
    mutating func assertUnique(whenInserting newElement: Element) {
        assert(!contains(newElement))
        insert(newElement)
    }
}


extension Set {
    static func append(lhs: Self?, element: Element) -> Set<Element> {
        let newSet = Set([element])
        if let existingSet = lhs {
            return existingSet.union(newSet)
        } else {
            return newSet
        }
    }
}
//
//func +=<Element>(lhs: inout Set<Element>?, element: Element) where Element: Hashable {
//    lhs = Set<Element>.append(lhs: lhs, element: element)
//}

extension Set {
    static var empty: Self { .init() }
}
