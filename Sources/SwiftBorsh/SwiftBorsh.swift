import Base58
import ByteBuffer

public typealias BorshByteBuffer = ByteBuffer

@attached(extension, conformances: BorshEncodable, names: named(borshEncode(to:)))
public macro BorshEncodable() =
    #externalMacro(module: "SwiftBorshMacros", type: "BorshEncodableMacro")

@attached(extension, conformances: BorshDecodable, names: named(init(fromBorshBuffer:)))
public macro BorshDecodable() =
    #externalMacro(module: "SwiftBorshMacros", type: "BorshDecodableMacro")

@attached(
    extension, conformances: BorshEncodable, BorshDecodable,
    names: named(borshEncode(to:)),
    named(init(fromBorshBuffer:)))
public macro BorshCodable() =
    #externalMacro(module: "SwiftBorshMacros", type: "BorshCodableMacro")

public enum BorshEncoder {
    public static func encode(_ value: any BorshEncodable) throws(BorshEncodingError) -> [UInt8] {
        var buffer = ByteBuffer()
        try value.borshEncode(to: &buffer)
        return buffer.readBytes(length: buffer.readableBytes) ?? []
    }

    public static func base58Encode(_ value: any BorshEncodable) throws
        -> String
    {
        let bytes = try encode(value)
        return Base58.encode(bytes)
    }
}

public enum BorshDecoder {
    public static func decode<T: BorshDecodable>(_ data: [UInt8], into: T.Type)
        throws(BorshDecodingError)
        -> T
    {
        var buffer = ByteBuffer(bytes: data)
        return try T.init(fromBorshBuffer: &buffer)
    }

    public static func base58Decode<T: BorshDecodable>(_ data: String, into: T.Type)
        throws -> T
    {
        let bytes = try Base58.decode(data)
        return try decode(bytes, into: T.self)
    }
}
