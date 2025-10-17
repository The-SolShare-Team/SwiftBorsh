extension BorshCodable where Self: FixedWithFloatingPoint {
    public func borshEncode(to buffer: inout BorshByteBuffer) throws(BorshEncodingError) {
        if isNaN { throw BorshEncodingError.InvalidValue }
        buffer.writeInteger(self.bitPattern, endianness: .little)
    }

    public init(fromBorshBuffer buffer: inout BorshByteBuffer) throws(BorshDecodingError) {
        guard let bitPattern = buffer.readInteger(endianness: .little, as: BitPattern.self) else {
            throw BorshDecodingError.EndOfBuffer
        }
        self.init(bitPattern: bitPattern)
    }
}

@available(macOS 11.0, *)
extension Float16: BorshCodable {}
extension Float32: BorshCodable {}
extension Float64: BorshCodable {}
