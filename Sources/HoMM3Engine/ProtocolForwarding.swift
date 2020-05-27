//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-24.
//

import Foundation

// Influenced by Rob Mayoff's protocol forwarding technique presented in Swift Forums here: https://forums.swift.org/t/newtype-for-swift/35859/68

public protocol BaseTag {
    associatedtype RawValue
}

open class TagBase<RawValue>: BaseTag {
    private init() { fatalError() }
}

public struct NewType<Tag: BaseTag> {
    public typealias RawValue = Tag.RawValue
    
    public init(rawValue: Tag.RawValue) {
        self.rawValue = rawValue
    }
    
    public var rawValue: Tag.RawValue
}

// MARKL Equatable
public protocol EquatableTag: BaseTag {
    static func areEqual(_ lhs: RawValue, _ rhs: RawValue) -> Bool
}

extension NewType: Equatable where Tag: EquatableTag {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return Tag.areEqual(lhs.rawValue, rhs.rawValue)
    }
}

extension EquatableTag where RawValue: Equatable {
    public static func areEqual(_ lhs: RawValue, _ rhs: RawValue) -> Bool {
        return lhs == rhs
    }
}

// MARK: Hashable
public protocol HashableTag: EquatableTag {
    static func hash(_ rawValue: RawValue, into hasher: inout Hasher)
}

extension HashableTag where RawValue: Hashable {
    public static func hash(_ rawValue: RawValue, into hasher: inout Hasher) {
        rawValue.hash(into: &hasher)
    }
}

extension NewType: Hashable where Tag: HashableTag {
    public func hash(into hasher: inout Hasher) {
        Tag.hash(rawValue, into: &hasher)
    }
}

// MARK: Comparable
public protocol ComparableTag: EquatableTag {
    static func `is`(_ lhs: RawValue, lessThan rhs: RawValue) -> Bool
}

extension ComparableTag where RawValue: Comparable {
    public static func `is`(_ lhs: RawValue, lessThan rhs: RawValue) -> Bool {
        return lhs < rhs
    }
}

extension NewType: Comparable where Tag: ComparableTag {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return Tag.is(lhs.rawValue, lessThan: rhs.rawValue)
    }
}

// MARK: Encodable

public protocol EncodableTag: BaseTag {
    static func encode(_ rawValue: RawValue, into encoder: Encoder) throws
}

extension EncodableTag where RawValue: Encodable {
    public static func encode(_ rawValue: RawValue, into encoder: Encoder) throws {
        try rawValue.encode(to: encoder)
    }
}

extension NewType: Encodable where Tag: EncodableTag {
    public func encode(to encoder: Encoder) throws {
        try Tag.encode(rawValue, into: encoder)
    }
}

// MARK: Decodable
public protocol DecodableTag: BaseTag {
    static func decode(from decoder: Decoder) throws -> RawValue
}

extension DecodableTag where RawValue: Decodable {
    public static func decode(from decoder: Decoder) throws -> RawValue {
        return try RawValue(from: decoder)
    }
}

extension NewType: Decodable where Tag: DecodableTag {
    public init(from decoder: Decoder) throws {
        self.init(rawValue: try Tag.decode(from: decoder))
    }
}

public protocol CodableTag: EncodableTag, DecodableTag { }

// MARK: CustomStringConveritble
public protocol CustomStringConvertibleTag: BaseTag {
    static func description(of rawValue: RawValue) -> String
}

extension CustomStringConvertibleTag where RawValue: CustomStringConvertible {
    public static func description(of rawValue: RawValue) -> String {
        return rawValue.description
    }
}

extension NewType: CustomStringConvertible where Tag: CustomStringConvertibleTag {
    public var description: String { Tag.description(of: rawValue) }
}

// MARK: Common Tags
protocol CommonTags: HashableTag, CustomStringConvertibleTag, CodableTag { }


// MARK: ExpressibleByIntegerLiteral
public protocol ExpressibleByIntegerLiteralTag: BaseTag {
    associatedtype IntegerLiteralType: _ExpressibleByBuiltinIntegerLiteral
    static func integerLiteral(_ literal: IntegerLiteralType) -> RawValue
}

extension NewType: ExpressibleByIntegerLiteral where Tag: ExpressibleByIntegerLiteralTag {
    public typealias IntegerLiteralType = Tag.IntegerLiteralType
    
    public init(integerLiteral: IntegerLiteralType) {
        self.init(rawValue: Tag.integerLiteral(integerLiteral))
    }
}

extension ExpressibleByIntegerLiteralTag where RawValue: ExpressibleByIntegerLiteral, RawValue.IntegerLiteralType == IntegerLiteralType {
    public static func integerLiteral(_ literal: IntegerLiteralType) -> RawValue {
        RawValue(integerLiteral: literal)
    }
}

// MARK: Additive
public protocol AdditiveArithmeticTag: EquatableTag {
    static var zero: RawValue { get }
    static func addition(_ lhs: RawValue, _ rhs: RawValue) -> RawValue
    static func subtraction(_ lhs: RawValue, _ rhs: RawValue) -> RawValue
}

extension AdditiveArithmeticTag where RawValue: AdditiveArithmetic {
    public static var zero: RawValue { RawValue.zero }
    public static func addition(_ lhs: RawValue, _ rhs: RawValue) -> RawValue { lhs + rhs }
    public static func subtraction(_ lhs: RawValue, _ rhs: RawValue) -> RawValue { lhs - rhs }
}

extension NewType: AdditiveArithmetic where Tag: AdditiveArithmeticTag {
    public static var zero: Self { .init(rawValue: Tag.zero) }
    
    public static func + (lhs: Self, rhs: Self) -> Self {
        return .init(rawValue: Tag.addition(lhs.rawValue, rhs.rawValue))
    }
    
    public static func - (lhs: Self, rhs: Self) -> Self {
        return .init(rawValue: Tag.subtraction(lhs.rawValue, rhs.rawValue))
    }
}

// MARK: NumericTag
public protocol NumericTag: AdditiveArithmeticTag, ExpressibleByIntegerLiteralTag {
    associatedtype Magnitude: Comparable, Numeric
    static func exactly<T: BinaryInteger>(_ source: T) -> RawValue?
    static func magnitude(of rawValue: RawValue) -> Magnitude
    static func multiplication(_ lhs: RawValue, _ rhs: RawValue) -> RawValue
    static func inPlaceMultiplication(_ lhs: inout RawValue, _ rhs: RawValue)
}

extension NumericTag where RawValue: Numeric, RawValue.Magnitude == Magnitude {
    public static func exactly<T: BinaryInteger>(_ source: T) -> RawValue? { RawValue(exactly: source) }
    public static func magnitude(of rawValue: RawValue) -> Magnitude { rawValue.magnitude }
    public static func multiplication(_ lhs: RawValue, _ rhs: RawValue) -> RawValue { lhs * rhs }
    public static func inPlaceMultiplication(_ lhs: inout RawValue, _ rhs: RawValue) { lhs *= rhs }
}

extension NewType: Numeric where Tag: NumericTag {
    public typealias Magnitude = Tag.Magnitude
    
    public init?<T>(exactly source: T) where T : BinaryInteger {
        guard let rawValue = Tag.exactly(source) else { return nil }
        self.init(rawValue: rawValue)
    }
    
    public var magnitude: Tag.Magnitude { Tag.magnitude(of: rawValue) }
    
    public static func * (lhs: Self, rhs: Self) -> Self {
        return .init(rawValue: Tag.multiplication(lhs.rawValue, rhs.rawValue))
    }
    
    public static func *= (lhs: inout Self, rhs: Self) {
        Tag.inPlaceMultiplication(&lhs.rawValue, rhs.rawValue)
    }
}

// MARK: SignedNumeric
public protocol SignedNumericTag: NumericTag {
    static func negate(_ rawValue: inout RawValue)
    static func negative(of rawValue: RawValue) -> RawValue
}

extension SignedNumericTag {
    public static func negate(_ rawValue: inout RawValue) {
        rawValue = Self.subtraction(Self.zero, rawValue)
    }
    
    public static func negative(of rawValue: RawValue) -> RawValue {
        return Self.subtraction(Self.zero, rawValue)
    }
}
extension SignedNumericTag where RawValue: SignedNumeric {
    public static func negate(_ rawValue: inout RawValue) { rawValue.negate() }
    public static func negative(of rawValue: RawValue) -> RawValue { -rawValue }
}

extension NewType: SignedNumeric where Tag: SignedNumericTag {
    public mutating func negate() { Tag.negate(&rawValue) }
    public static prefix func - (_ value: Self) -> Self {
        return .init(rawValue: Tag.negative(of: value.rawValue))
    }
}

// MARK: Strideable
public protocol StrideableTag: ComparableTag {
    associatedtype Stride: Comparable, SignedNumeric
    
    static func advance(_ rawValue: RawValue, by n: Stride) -> RawValue
    static func distance(from start: RawValue, to end: RawValue) -> Stride
}

extension StrideableTag where RawValue: Strideable, RawValue.Stride == Stride {
    public static func advance(_ rawValue: RawValue, by n: Stride) -> RawValue {
        return rawValue.advanced(by: n)
    }
    
    public static func distance(from start: RawValue, to end: RawValue) -> Stride {
        return distance(from: start, to: end)
    }
}

extension NewType: Strideable where Tag: StrideableTag {
    public typealias Stride = Tag.Stride
    
    public func advanced(by n: Tag.Stride) -> Self {
        return .init(rawValue: Tag.advance(rawValue, by: n))
    }
    
    public func distance(to other: Self) -> Tag.Stride {
        return Tag.distance(from: rawValue, to: other.rawValue)
    }
}

// MARK: BinaryInteger
public protocol BinaryIntegerTag: HashableTag, NumericTag, StrideableTag, CustomStringConvertibleTag /*where Self.Magnitude == Self.Magnitude.Magnitude */ {
    associatedtype Words: RandomAccessCollection where Self.Words.Element == UInt, Self.Words.Index == Int
    
    static func exactlyFloat<T: BinaryFloatingPoint>(_ source: T) -> RawValue?
    
    static func truncatingIfNeeded<T: BinaryInteger>(_ source: T) -> RawValue
    static func clamping<T: BinaryInteger>(_ source: T) -> RawValue
    static func fromSource<T: BinaryInteger>(_ source: T) -> RawValue
    static func fromSource<T: BinaryFloatingPoint>(_ source: T) -> RawValue // default impl provided ?
    static func newEmpty() -> RawValue
    
    
    static func bitWidth(of rawValue: RawValue) -> Int
    static func trailingZeroBitCount(of rawValue: RawValue) -> Int
    static func words(of rawValue: RawValue) -> Self.Words
    
    static func isSignedCheckingRawValue() -> Bool
    
    static func modulus(lhs: RawValue, rhs: RawValue) -> RawValue
    static func inPlaceModulus(_ lhs: inout RawValue, _ rhs: RawValue)
    static func inPlaceBitwiseAND(_ lhs: inout RawValue, _ rhs: RawValue)
    static func inPlaceXOR(_ lhs: inout RawValue, _ rhs: RawValue)
    static func inPlaceOR(_ lhs: inout RawValue, _ rhs: RawValue)
    static func inPlaceDivision(dividend: inout RawValue, withDivisor divisor: RawValue)
    static func dividing(_ dividend: RawValue, withDivisor divisor: RawValue) -> RawValue
    
    static func inverse(using: RawValue) -> RawValue
    
    static func shiftingDigitsToRight<RHS: BinaryInteger>(_ lhs: inout RawValue, _ rhs: RHS)
    static func shiftingDigitsToLeft<RHS: BinaryInteger>(_ lhs: inout RawValue, _ rhs: RHS)
}

extension NewType: BinaryInteger where Tag: BinaryIntegerTag, Self.Magnitude: BinaryInteger, Self.Magnitude == Self.Magnitude.Magnitude {
    
    public static func <<= <RHS>(lhs: inout Self, rhs: RHS) where RHS : BinaryInteger {
        Tag.shiftingDigitsToLeft(&lhs.rawValue, rhs)
    }
    
    public static func >>= <RHS>(lhs: inout Self, rhs: RHS) where RHS : BinaryInteger {
        Tag.shiftingDigitsToRight(&lhs.rawValue, rhs)
    }
    
    
    public prefix static func ~ (x: Self) -> Self {
        self.init(rawValue: Tag.inverse(using: x.rawValue))
    }
    
    public static var isSigned: Bool {
        Tag.isSignedCheckingRawValue()
    }
    
    public typealias Words = Tag.Words
    
    public init() {
        self.init(rawValue: Tag.newEmpty())
    }
    
    public init?<T>(exactly source: T) where T: BinaryFloatingPoint {
        guard let rawValue = Tag.exactlyFloat(source) else { return nil }
        self.init(rawValue: rawValue)
    }
    
    public init<T>(truncatingIfNeeded source: T) where T : BinaryInteger {
        self.init(rawValue: Tag.truncatingIfNeeded(source))
    }
    
    public init<T>(clamping source: T) where T : BinaryInteger {
        self.init(rawValue: Tag.clamping(source))
    }
    
    public init<T>(_ source: T) where T : BinaryInteger {
        self.init(rawValue: Tag.fromSource(source))
    }
    
    public init<T>(_ source: T) where T : BinaryFloatingPoint {
        self.init(rawValue: Tag.fromSource(source))
    }
    
    public var bitWidth: Int {
        Tag.bitWidth(of: rawValue)
    }
    
    public var trailingZeroBitCount: Int { Tag.trailingZeroBitCount(of: rawValue) }
    
    public var words: Self.Words {
        Tag.words(of: rawValue)
    }
    
    public static func % (lhs: Self, rhs: Self) -> Self {
        Self.init(rawValue: Tag.modulus(lhs: lhs.rawValue, rhs: rhs.rawValue))
    }
    
    public static func %= (lhs: inout Self, rhs: Self) {
        Tag.inPlaceModulus(&lhs.rawValue, rhs.rawValue)
    }
    
    public static func &= (lhs: inout Self, rhs: Self) {
        Tag.inPlaceBitwiseAND(&lhs.rawValue, rhs.rawValue)
    }
    
    public static func / (lhs: Self, rhs: Self) -> Self {
        Self.init(rawValue: Tag.dividing(lhs.rawValue, withDivisor: rhs.rawValue))
    }
    
    public static func /= (lhs: inout Self, rhs: Self) {
        Tag.inPlaceDivision(dividend: &lhs.rawValue, withDivisor: rhs.rawValue)
    }
    
    public static func ^= (lhs: inout Self, rhs: Self) {
        Tag.inPlaceXOR(&lhs.rawValue, rhs.rawValue)
    }
    
    public static func |= (lhs: inout Self, rhs: Self) {
        Tag.inPlaceOR(&lhs.rawValue, rhs.rawValue)
        
    }
}


extension BinaryIntegerTag where RawValue: BinaryInteger, RawValue.Words == Words {
    
    public static func shiftingDigitsToLeft<RHS: BinaryInteger>(_ lhs: inout RawValue, _ rhs: RHS) {
        lhs <<= rhs
    }
    
    public static func shiftingDigitsToRight<RHS: BinaryInteger>(_ lhs: inout RawValue, _ rhs: RHS) {
        lhs >>= rhs
    }
    
    public static func inPlaceDivision(dividend: inout RawValue, withDivisor divisor: RawValue) {
        dividend /= divisor
    }
    
    public static func dividing(_ dividend: RawValue, withDivisor divisor: RawValue) -> RawValue {
        dividend / divisor
    }
    
    public static func modulus(lhs: RawValue, rhs: RawValue) -> RawValue {
        lhs % rhs
    }
    
    public static func inPlaceModulus(_ lhs: inout RawValue, _ rhs: RawValue) {
        lhs %= rhs
    }
    
    public static func inPlaceBitwiseAND(_ lhs: inout RawValue, _ rhs: RawValue) {
        lhs &= rhs
    }
    
    public static func inPlaceXOR(_ lhs: inout RawValue, _ rhs: RawValue) {
        lhs ^= rhs
    }
    
    public static func inPlaceOR(_ lhs: inout RawValue, _ rhs: RawValue) {
        lhs |= rhs
    }
    
    public static func exactlyFloat<T>(_ source: T) -> RawValue? where T: BinaryFloatingPoint {
        RawValue(exactly: source)
    }
    
    
    public static func truncatingIfNeeded<T: BinaryInteger>(_ source: T) -> RawValue {
        RawValue(truncatingIfNeeded: source)
    }
    
    public static func clamping<T: BinaryInteger>(_ source: T) -> RawValue {
        RawValue(clamping: source)
    }
    
    public static func fromSource<T: BinaryInteger>(_ source: T) -> RawValue {
        RawValue(source)
    }
    
    public static func fromSource<T: BinaryFloatingPoint>(_ source: T) -> RawValue {
        RawValue(source)
    }
    
    public static func newEmpty() -> RawValue {
        RawValue()
    }
    
    public static func bitWidth(of rawValue: RawValue) -> Int {
        rawValue.bitWidth
    }
    
    public static func trailingZeroBitCount(of rawValue: RawValue) -> Int {
        rawValue.trailingZeroBitCount
    }
    
    public static func words(of rawValue: RawValue) -> Self.Words {
        rawValue.words
    }
    
    public static func isSignedCheckingRawValue() -> Bool {
        RawValue.isSigned
    }
    
    public static func inverse(using rawValue: RawValue) -> RawValue {
        ~rawValue
    }
}

// MARK: LosslessStringConvertibleTag
public protocol LosslessStringConvertibleTag: CustomStringConvertibleTag {
    static func fromDescription(_ description: String) -> RawValue?
}

extension LosslessStringConvertibleTag where RawValue: LosslessStringConvertible {
    public static func fromDescription(_ description: String) -> RawValue? {
        RawValue(description)
    }
}

extension NewType: LosslessStringConvertible where Tag: LosslessStringConvertibleTag {
    public init?(_ description: String) {
        guard let rawValue = Tag.fromDescription(description) else { return nil }
        self.init(rawValue: rawValue)
    }
}


// MARK: FixedWidthIntegerTag
public protocol FixedWidthIntegerTag: BinaryIntegerTag, LosslessStringConvertibleTag {
    
    static func fromText<S: StringProtocol>(_ text: S, radix: Int) -> RawValue?
    static func truncatingBits(_ bits: UInt) -> RawValue
    static func bitWidthFromRawValue() -> Int
    static func maxRawValue() -> RawValue
    static func minRawValue() -> RawValue
    static func addingReportingOverflowFromRawValue(addTo base: RawValue, _ rhs: RawValue) -> (partialValue: RawValue, overflow: Bool)
    static func subtactingReportingOverflowFromRawValue(_ lhs: RawValue, _ rhs: RawValue) -> (partialValue: RawValue, overflow: Bool)
    static func multipliedReportingOverflowFromRawValue(_ lhs: RawValue, _ rhs: RawValue) -> (partialValue: RawValue, overflow: Bool)
    static func dividingReportingOverflowFromRawValue(_ lhs: RawValue, _ rhs: RawValue) -> (partialValue: RawValue, overflow: Bool)
    static func remainderReportingOverflowFromRawValue(_ lhs: RawValue, _ rhs: RawValue) -> (partialValue: RawValue, overflow: Bool)
    
    static func dividingFullWidthFromRawValue(_ base: RawValue, _ dividend: (high: RawValue, low: Magnitude)) -> (quotient: RawValue, remainder: RawValue)
    
    static func nonzeroBitCountUsingRawValue(_ rawValue: RawValue) -> Int
    static func leadingZeroBitCountUsingRawValue(_ rawValue: RawValue) -> Int
    static func byteSwappedUsingRawValue(_ rawValue: RawValue) -> RawValue
}

extension FixedWidthIntegerTag where RawValue: FixedWidthInteger, RawValue.Magnitude == Magnitude { //, RawValue.Words == Words {
    public static func fromText<S: StringProtocol>(_ text: S, radix: Int) -> RawValue? {
        RawValue(text, radix: radix)
    }
    
    public static func truncatingBits(_ bits: UInt) -> RawValue {
        RawValue(bits)
    }
    public static func bitWidthFromRawValue() -> Int {
        RawValue.bitWidth
    }
    public static func maxRawValue() -> RawValue {
        RawValue.max
    }
    public static func minRawValue() -> RawValue {
        RawValue.min
    }
    
    public static func addingReportingOverflowFromRawValue(addTo base: RawValue, _ rhs: RawValue) -> (partialValue: RawValue, overflow: Bool) {
        base.addingReportingOverflow(rhs)
    }
    
    
    public static func subtactingReportingOverflowFromRawValue(_ lhs: RawValue, _ rhs: RawValue) -> (partialValue: RawValue, overflow: Bool) {
        lhs.subtractingReportingOverflow(rhs)
    }
    
    public static func multipliedReportingOverflowFromRawValue(_ lhs: RawValue, _ rhs: RawValue) -> (partialValue: RawValue, overflow: Bool) {
        lhs.multipliedReportingOverflow(by: rhs)
    }
    
    public static func dividingReportingOverflowFromRawValue(_ lhs: RawValue, _ rhs: RawValue) -> (partialValue: RawValue, overflow: Bool) {
        lhs.remainderReportingOverflow(dividingBy: rhs)
    }
    
    public static func remainderReportingOverflowFromRawValue(_ lhs: RawValue, _ rhs: RawValue) -> (partialValue: RawValue, overflow: Bool) {
        lhs.remainderReportingOverflow(dividingBy: rhs)
    }
    
    public static func dividingFullWidthFromRawValue(_ base: RawValue, _ dividend: (high: RawValue, low: RawValue.Magnitude)) -> (quotient: RawValue, remainder: RawValue) {
        return base.dividingFullWidth((dividend.high, dividend.low))
    }
    
    public static func nonzeroBitCountUsingRawValue(_ rawValue: RawValue) -> Int {
        rawValue.nonzeroBitCount
    }
    public static func leadingZeroBitCountUsingRawValue(_ rawValue: RawValue) -> Int {
        rawValue.leadingZeroBitCount
    }
    public static func byteSwappedUsingRawValue(_ rawValue: RawValue) -> RawValue {
        rawValue.byteSwapped
    }
}

extension NewType: FixedWidthInteger where Tag: FixedWidthIntegerTag, Self.Magnitude : FixedWidthInteger, Self.Stride : FixedWidthInteger, Self.Stride : SignedInteger, Self.Magnitude == Self.Magnitude.Magnitude {
    public static var bitWidth: Int {
        Tag.bitWidthFromRawValue()
    }
    
    public static var max: Self {
        self.init(rawValue: Tag.maxRawValue())
    }
    
    public static var min: Self {
        self.init(rawValue: Tag.minRawValue())
    }
    
    public func addingReportingOverflow(_ rhs: Self) -> (partialValue: Self, overflow: Bool) {
        let (partialRawValue, didOverflow) = Tag.addingReportingOverflowFromRawValue(addTo: rawValue, rhs.rawValue)
        return (Self.init(rawValue: partialRawValue), didOverflow)
    }
    
    public func subtractingReportingOverflow(_ rhs: Self) -> (partialValue: Self, overflow: Bool) {
        let (partialRawValue, didOverflow) = Tag.subtactingReportingOverflowFromRawValue(rawValue, rhs.rawValue)
        return (Self.init(rawValue: partialRawValue), didOverflow)
    }
    
    public func multipliedReportingOverflow(by rhs: Self) -> (partialValue: Self, overflow: Bool) {
        let (partialRawValue, didOverflow) = Tag.multipliedReportingOverflowFromRawValue(rawValue, rhs.rawValue)
        return (Self.init(rawValue: partialRawValue), didOverflow)
    }
    
    public func dividedReportingOverflow(by rhs: Self) -> (partialValue: Self, overflow: Bool) {
        let (partialRawValue, didOverflow) = Tag.dividingReportingOverflowFromRawValue(rawValue, rhs.rawValue)
        return (Self.init(rawValue: partialRawValue), didOverflow)
    }
    
    public func remainderReportingOverflow(dividingBy rhs: Self) -> (partialValue: Self, overflow: Bool) {
        let (partialRawValue, didOverflow) = Tag.remainderReportingOverflowFromRawValue(rawValue, rhs.rawValue)
        return (Self.init(rawValue: partialRawValue), didOverflow)
    }
    
    public func dividingFullWidth(_ dividend: (high: Self, low: Tag.Magnitude)) -> (quotient: Self, remainder: Self) {
        
        let (quotient, remainder) = Tag.dividingFullWidthFromRawValue(rawValue, (dividend.high.rawValue, dividend.low))
        
        return (Self.init(rawValue: quotient), Self.init(rawValue: remainder))
    }
    
    public var nonzeroBitCount: Int {
        Tag.nonzeroBitCountUsingRawValue(rawValue)
    }
    
    public var leadingZeroBitCount: Int {
        Tag.leadingZeroBitCountUsingRawValue(rawValue)
    }
    
    public var byteSwapped: Self {
        Self.init(rawValue: Tag.byteSwappedUsingRawValue(rawValue))
    }
    
    public init?<S>(_ text: S, radix: Int = 10) where S : StringProtocol {
        guard let rawValue = Tag.fromText(text, radix: radix) else { return nil }
        self.init(rawValue: rawValue)
    }
    
    public init(_truncatingBits bits: UInt) {
        self.init(rawValue: Tag.truncatingBits(bits))
    }
}

// MARK: UnsignedIntegerTag
public protocol UnsignedIntegerTag: BinaryIntegerTag {}

extension NewType: UnsignedInteger
where
    Tag: UnsignedIntegerTag,
    Self.Magnitude: BinaryInteger,
    Self.Magnitude == Self.Magnitude.Magnitude
{}


// MARK: UnsignedInt Tags
protocol UnsignedTags: CommonTags, UnsignedIntegerTag { }
extension TagBase where RawValue == UInt {
    public typealias Magnitude = RawValue.Magnitude
    public typealias IntegerLiteralType = RawValue.IntegerLiteralType
    public typealias Stride = RawValue.Stride
    public typealias Words = RawValue.Words
}

protocol UnsignedFixedWidthIntTags: UnsignedTags, FixedWidthIntegerTag { }
