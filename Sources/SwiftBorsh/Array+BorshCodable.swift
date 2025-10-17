extension Array: BorshEncodable where Element: BorshEncodable {
    public func borshEncode(to buffer: inout BorshByteBuffer) throws(BorshEncodingError) {
        try UInt32(self.count).borshEncode(to: &buffer)
        for el in self {
            try el.borshEncode(to: &buffer)
        }
    }
}

extension Array: BorshDecodable where Element: BorshDecodable {
    public init(fromBorshBuffer buffer: inout BorshByteBuffer) throws(BorshDecodingError) {
        guard let count = buffer.readInteger(endianness: .little, as: UInt32.self) else {
            throw BorshDecodingError.EndOfBuffer
        }
        self.init()
        self.reserveCapacity(Int(count))
        for i in 0..<Int(count) {
            self[i] = try Element(fromBorshBuffer: &buffer)
        }
    }
}
