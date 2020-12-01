//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-30.
//

import Foundation

public protocol Pushable {
    associatedtype Element
    mutating func push(_ element: Element)
}

public protocol Peekable {
    associatedtype Element
    func peek() -> Element?
    @discardableResult mutating func pop() -> Element?
}

extension Peekable {
    var isEmpty: Bool { peek() == nil }
}

public typealias Stacked = Peekable & Pushable

public struct Stack<Element>: Stacked, Equatable, CustomStringConvertible, ExpressibleByArrayLiteral where Element: Equatable {
    private var storage = [Element]()
}

public extension Stack {
    func peek() -> Element? { storage.first }
    
    mutating func push(_ element: Element) { storage.append(element) }
    
    mutating func pop() -> Element? { storage.popLast() }
}

// MARK: CustomStringConvertible
public extension Stack {
    var description: String { "\(storage)" }
}

// MARK: ExpressibleByArrayLiteral
public extension Stack {
    init(arrayLiteral elements: Self.Element...) { storage = elements }
}


