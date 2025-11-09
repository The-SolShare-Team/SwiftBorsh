extension BorshCodable where Self: FixedWidthInteger {
    public func borshEncode(to buffer: inout BorshByteBuffer) throws(BorshEncodingError) {
        buffer.writeInteger(self, endianness: .little)
    }

    public init(fromBorshBuffer buffer: inout BorshByteBuffer) throws(BorshDecodingError) {
        guard let int = buffer.readInteger(endianness: .little, as: Self.self) else {
            throw BorshDecodingError.endOfBuffer
        }
        self = int
    }
}

extension Int8: BorshCodable {}
extension UInt8: BorshCodable {}
extension Int16: BorshCodable {}
extension UInt16: BorshCodable {}
extension Int32: BorshCodable {}
extension UInt32: BorshCodable {}
extension Int64: BorshCodable {}
extension UInt64: BorshCodable {}
@available(iOS 18.0, macOS 15.0, *)
extension Int128: BorshCodable {}
@available(iOS 18.0, macOS 15.0, *)
extension UInt128: BorshCodable {}
