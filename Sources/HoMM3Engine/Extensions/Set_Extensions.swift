//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-24.
//

import Foundation


extension Set {
    
    static var empty: Self { .init() }
    
    static func append(lhs: Self?, element: Element) -> Set<Element> {
        let newSet = Set([element])
        if let existingSet = lhs {
            return existingSet.union(newSet)
        } else {
            return newSet
        }
    }
    
    static func remove(lhs: Self?, element: Element) -> (set: Set<Element>, didContainElement: Bool)  {
        guard var existingSet = lhs else { return (.empty, false) }
        let didContainElement = existingSet.remove(element) != nil
        return (existingSet, didContainElement)
    }
}

func +=<Element>(lhs: inout Set<Element>?, element: Element) where Element: Hashable {
    lhs = Set<Element>.append(lhs: lhs, element: element)
}

///Returns `true` iff the set did contain `element` before removal, else returns `false`
func -=<Element>(lhs: inout Set<Element>?, element: Element) -> Bool where Element: Hashable {
    let (newSet, didContain) = Set<Element>.remove(lhs: lhs, element: element)
    lhs = newSet
    return didContain
}
