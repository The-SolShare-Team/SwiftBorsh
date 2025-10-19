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
        let count = Int(try UInt32(fromBorshBuffer: &buffer))
        self.init()
        self.reserveCapacity(count)
        for i in 0..<count {
            self[i] = try Element(fromBorshBuffer: &buffer)
        }
    }
}
