extension Result: BorshEncodable where Success: BorshEncodable, Failure: BorshEncodable {
    public func borshEncode(to buffer: inout BorshByteBuffer) throws(BorshEncodingError) {
        switch self {
        case .success(let value):
            try true.borshEncode(to: &buffer)
            try value.borshEncode(to: &buffer)
        case .failure(let value):
            try false.borshEncode(to: &buffer)
            try value.borshEncode(to: &buffer)
        }
    }
}

extension Result: BorshDecodable where Success: BorshDecodable, Failure: BorshDecodable {
    public init(fromBorshBuffer buffer: inout BorshByteBuffer) throws(BorshDecodingError) {
        let success = try Bool(fromBorshBuffer: &buffer)
        if success {
            self = .success(try Success(fromBorshBuffer: &buffer))
        } else {
            self = .failure(try Failure(fromBorshBuffer: &buffer))
        }
    }
}
