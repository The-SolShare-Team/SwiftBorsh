extension Dictionary: BorshEncodable
where Key: Comparable, Key: BorshEncodable, Value: BorshEncodable {
    public func borshEncode(to buffer: inout BorshByteBuffer) throws(BorshEncodingError) {
        try UInt32(self.count).borshEncode(to: &buffer)
        for (key, value) in self.sorted(by: { $0.0 < $1.0 }) {
            try key.borshEncode(to: &buffer)
            try value.borshEncode(to: &buffer)
        }
    }
}

extension Dictionary: BorshDecodable where Key: BorshDecodable, Value: BorshDecodable {
    public init(fromBorshBuffer buffer: inout BorshByteBuffer) throws(BorshDecodingError) {
        let count = Int(try UInt32(fromBorshBuffer: &buffer))
        self.init(minimumCapacity: count)
        for _ in 0..<count {
            let key = try Key(fromBorshBuffer: &buffer)
            let value = try Value(fromBorshBuffer: &buffer)
            self[key] = value
        }
    }
}
