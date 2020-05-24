//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-24.
//

import Foundation

// MARK: Identifier
public struct Identifier<RawValue, Entity>: Hashable, RawRepresentable where RawValue: Hashable {
   
    public let rawValue: RawValue
    
    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
}

// MARK: ExpressibleByIntegerLiteral
extension Identifier: ExpressibleByIntegerLiteral where RawValue == Int {
    public typealias IntegerLiteralType = RawValue
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(rawValue: value)
    }
}

// MARK: ExpressibleByStringLiteral
extension Identifier: ExpressibleByUnicodeScalarLiteral where RawValue == String {
    public typealias UnicodeScalarLiteralType = StringLiteralType
}

extension Identifier: ExpressibleByExtendedGraphemeClusterLiteral where RawValue == String {
    public typealias ExtendedGraphemeClusterLiteralType = UnicodeScalarLiteralType
}

extension Identifier: ExpressibleByStringLiteral where RawValue == String {
    public typealias StringLiteralType = RawValue
    public init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value)
    }
}
