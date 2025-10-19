extension Optional: BorshEncodable where Wrapped: BorshEncodable {
    public func borshEncode(to buffer: inout BorshByteBuffer) throws(BorshEncodingError) {
        if let value = self {
            try true.borshEncode(to: &buffer)
            try value.borshEncode(to: &buffer)
        } else {
            try false.borshEncode(to: &buffer)
            return
        }
    }
}

extension Optional: BorshDecodable where Wrapped: BorshDecodable {
    public init(fromBorshBuffer buffer: inout BorshByteBuffer) throws(BorshDecodingError) {
        let some = try Bool(fromBorshBuffer: &buffer)
        if some {
            self = try Wrapped(fromBorshBuffer: &buffer)
        } else {
            self = nil
        }
    }
}
