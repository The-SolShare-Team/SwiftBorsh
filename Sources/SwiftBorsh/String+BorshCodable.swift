extension String: BorshCodable {
    public func borshEncode(to buffer: inout BorshByteBuffer) throws(BorshEncodingError) {
        try UInt32(utf8.count).borshEncode(to: &buffer)
        buffer.writeString(self)
    }

    public init(fromBorshBuffer buffer: inout BorshByteBuffer) throws(BorshDecodingError) {
        guard let count = buffer.readInteger(endianness: .little, as: UInt32.self) else {
            throw BorshDecodingError.EndOfBuffer
        }
        guard let str = buffer.readString(length: Int(count)) else {
            throw BorshDecodingError.EndOfBuffer
        }
        self = str
    }
}
