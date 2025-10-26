extension Bool: BorshCodable {
    public func borshEncode(to buffer: inout BorshByteBuffer) throws(BorshEncodingError) {
        try UInt8(self ? 1 : 0).borshEncode(to: &buffer)
    }

    public init(fromBorshBuffer buffer: inout BorshByteBuffer) throws(BorshDecodingError) {
        let int = try UInt8(fromBorshBuffer: &buffer)
        switch int {
        case 0: self = false
        case 1: self = true
        default: throw BorshDecodingError.invalidValue
        }
    }
}
