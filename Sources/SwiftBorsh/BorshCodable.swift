public enum BorshEncodingError: Error, CustomStringConvertible {
    case UnsupportedType(any Any.Type)
    case InvalidValue
    case EnumNotEnumerable(any Any.Type)

    public var description: String {
        switch self {
        case .UnsupportedType(let t): "Unsupported type \(t)"
        case .InvalidValue: "Invalid value"
        case .EnumNotEnumerable(let t): "Enum \(t) does not conform to CaseIterable"
        }
    }
}

public enum BorshDecodingError: Error, CustomStringConvertible {
    case EndOfBuffer

    public var description: String {
        switch self {
        case .EndOfBuffer: "Unexpected end of buffer"
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
