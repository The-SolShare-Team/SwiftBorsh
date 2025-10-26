extension BorshCodable where Self: FixedWithFloatingPoint {
    public func borshEncode(to buffer: inout BorshByteBuffer) throws(BorshEncodingError) {
        if isNaN { throw BorshEncodingError.invalidValue }
        buffer.writeInteger(self.bitPattern, endianness: .little)
    }

    public init(fromBorshBuffer buffer: inout BorshByteBuffer) throws(BorshDecodingError) {
        guard let bitPattern = buffer.readInteger(endianness: .little, as: BitPattern.self) else {
            throw BorshDecodingError.endOfBuffer
        }
        self.init(bitPattern: bitPattern)
    }
}

#if arch(arm64)
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    extension Float16: BorshCodable {}
#endif
extension Float32: BorshCodable {}
extension Float64: BorshCodable {}
