extension Set: BorshEncodable where Element: Comparable, Element: BorshEncodable {
    public func borshEncode(to buffer: inout BorshByteBuffer) throws(BorshEncodingError) {
        try UInt32(self.count).borshEncode(to: &buffer)
        for value in self.sorted() {
            try value.borshEncode(to: &buffer)
        }
    }
}

extension Set: BorshDecodable where Element: BorshDecodable {
    public init(fromBorshBuffer buffer: inout BorshByteBuffer) throws(BorshDecodingError) {
        let count = Int(try UInt32(fromBorshBuffer: &buffer))
        self.init(minimumCapacity: count)
        for _ in 0..<count {
            self.insert(try Element(fromBorshBuffer: &buffer))
        }
    }
}
