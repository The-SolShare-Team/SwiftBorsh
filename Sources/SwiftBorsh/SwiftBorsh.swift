import ByteBuffer

public typealias BorshByteBuffer = ByteBuffer

@attached(extension, conformances: BorshEncodable, names: named(borshEncode(to:)))
public macro BorshEncodable() =
    #externalMacro(module: "SwiftBorshMacros", type: "BorshEncodableMacro")

@attached(extension, conformances: BorshDecodable, names: named(init(fromBorshBuffer:)))
public macro BorshDecodable() =
    #externalMacro(module: "SwiftBorshMacros", type: "BorshDecodableMacro")

public struct BorshEncoder {
    public static func encode(_ value: any BorshEncodable) throws(BorshEncodingError) -> [UInt8] {
        var buffer = ByteBuffer()
        try value.borshEncode(to: &buffer)
        return buffer.readBytes(length: buffer.readableBytes) ?? []
    }
}

public struct BorshDecoder {
    public static func decode<T: BorshDecodable>(_ data: [UInt8], into: T.Type)
        throws(BorshDecodingError)
        -> T
    {
        var buffer = ByteBuffer(bytes: data)
        return try T.init(fromBorshBuffer: &buffer)
    }
}
