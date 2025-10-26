public enum BorshEncodingError: Error, CustomStringConvertible {
    case unsupportedType(any Any.Type)
    case invalidValue

    public var description: String {
        switch self {
        case .unsupportedType(let t): "Unsupported type \(t)"
        case .invalidValue: "Invalid value"
        }
    }
}

public enum BorshDecodingError: Error, CustomStringConvertible {
    case endOfBuffer
    case invalidValue

    public var description: String {
        switch self {
        case .endOfBuffer: "Unexpected end of buffer"
        case .invalidValue: "Invalid value"
        }
    }
}

public protocol BorshEncodable {
    func borshEncode(to buffer: inout BorshByteBuffer) throws(BorshEncodingError)
}

public protocol BorshDecodable {
    init(fromBorshBuffer buffer: inout BorshByteBuffer) throws(BorshDecodingError)
}

public protocol BorshCodable: BorshEncodable, BorshDecodable {}
