# SwiftBorsh API Reference

Complete API documentation for SwiftBorsh.

## Table of Contents

- [Core Protocols](#core-protocols)
- [Macros](#macros)
- [Encoder and Decoder](#encoder-and-decoder)
- [Error Types](#error-types)
- [Type Extensions](#type-extensions)
- [Buffer Type](#buffer-type)

## Core Protocols

### BorshEncodable

Protocol for types that can be encoded to Borsh binary format.

```swift
public protocol BorshEncodable {
    func borshEncode(to buffer: inout BorshByteBuffer) throws(BorshEncodingError)
}
```

#### Methods

##### `borshEncode(to:)`

Encodes the value into the provided buffer.

**Declaration:**
```swift
func borshEncode(to buffer: inout BorshByteBuffer) throws(BorshEncodingError)
```

**Parameters:**
- `buffer`: A mutable reference to a `BorshByteBuffer` to write the encoded data into

**Throws:**
- `BorshEncodingError.unsupportedType`: When the type cannot be encoded
- `BorshEncodingError.invalidValue`: When the value is invalid for encoding

**Example:**
```swift
struct Point: BorshEncodable {
    let x: Int32
    let y: Int32

    func borshEncode(to buffer: inout BorshByteBuffer) throws(BorshEncodingError) {
        try x.borshEncode(to: &buffer)
        try y.borshEncode(to: &buffer)
    }
}
```

---

### BorshDecodable

Protocol for types that can be decoded from Borsh binary format.

```swift
public protocol BorshDecodable {
    init(fromBorshBuffer buffer: inout BorshByteBuffer) throws(BorshDecodingError)
}
```

#### Initializers

##### `init(fromBorshBuffer:)`

Creates an instance by decoding from the provided buffer.

**Declaration:**
```swift
init(fromBorshBuffer buffer: inout BorshByteBuffer) throws(BorshDecodingError)
```

**Parameters:**
- `buffer`: A mutable reference to a `BorshByteBuffer` to read the encoded data from

**Throws:**
- `BorshDecodingError.endOfBuffer`: When there's not enough data in the buffer
- `BorshDecodingError.invalidValue`: When an invalid value is encountered

**Example:**
```swift
struct Point: BorshDecodable {
    let x: Int32
    let y: Int32

    init(fromBorshBuffer buffer: inout BorshByteBuffer) throws(BorshDecodingError) {
        self.x = try Int32(fromBorshBuffer: &buffer)
        self.y = try Int32(fromBorshBuffer: &buffer)
    }
}
```

---

### BorshCodable

Combined protocol for types that support both encoding and decoding.

```swift
public protocol BorshCodable: BorshEncodable, BorshDecodable {}
```

This is a convenience protocol that combines `BorshEncodable` and `BorshDecodable`. Types conforming to `BorshCodable` can be both encoded and decoded.

**Example:**
```swift
struct Point: BorshCodable {
    let x: Int32
    let y: Int32

    func borshEncode(to buffer: inout BorshByteBuffer) throws(BorshEncodingError) {
        try x.borshEncode(to: &buffer)
        try y.borshEncode(to: &buffer)
    }

    init(fromBorshBuffer buffer: inout BorshByteBuffer) throws(BorshDecodingError) {
        self.x = try Int32(fromBorshBuffer: &buffer)
        self.y = try Int32(fromBorshBuffer: &buffer)
    }
}
```

## Macros

### @BorshEncodable

Attached macro that automatically generates `BorshEncodable` conformance.

**Declaration:**
```swift
@attached(extension, conformances: BorshEncodable, names: named(borshEncode(to:)))
public macro BorshEncodable()
```

**Usage:**
```swift
@BorshEncodable
struct User {
    let id: String
    let name: String
    let age: UInt8
}
```

**Generated Code:**
```swift
extension User: BorshEncodable {
    public func borshEncode(to buffer: inout BorshByteBuffer) throws(BorshEncodingError) {
        try id.borshEncode(to: &buffer)
        try name.borshEncode(to: &buffer)
        try age.borshEncode(to: &buffer)
    }
}
```

---

### @BorshDecodable

Attached macro that automatically generates `BorshDecodable` conformance.

**Declaration:**
```swift
@attached(extension, conformances: BorshDecodable, names: named(init(fromBorshBuffer:)))
public macro BorshDecodable()
```

**Usage:**
```swift
@BorshDecodable
struct User {
    let id: String
    let name: String
    let age: UInt8
}
```

**Generated Code:**
```swift
extension User: BorshDecodable {
    public init(fromBorshBuffer buffer: inout BorshByteBuffer) throws(BorshDecodingError) {
        self.id = try String(fromBorshBuffer: &buffer)
        self.name = try String(fromBorshBuffer: &buffer)
        self.age = try UInt8(fromBorshBuffer: &buffer)
    }
}
```

---

### @BorshCodable

Attached macro that automatically generates both `BorshEncodable` and `BorshDecodable` conformance.

**Declaration:**
```swift
@attached(
    extension, conformances: BorshEncodable, BorshDecodable,
    names: named(borshEncode(to:)),
    named(init(fromBorshBuffer:)))
public macro BorshCodable()
```

**Usage:**
```swift
@BorshCodable
struct User {
    let id: String
    let name: String
    let age: UInt8
}
```

This is equivalent to applying both `@BorshEncodable` and `@BorshDecodable`.

**Works with:**
- Structs with stored properties
- Enums (including those with associated values)
- Types with tuple properties
- Generic types (where generic parameters are `BorshCodable`)

## Encoder and Decoder

### BorshEncoder

Static encoder for converting `BorshEncodable` values to byte arrays.

```swift
public enum BorshEncoder {
    public static func encode(_ value: any BorshEncodable) throws(BorshEncodingError) -> [UInt8]
}
```

#### Methods

##### `encode(_:)`

Encodes a value conforming to `BorshEncodable` into a byte array.

**Declaration:**
```swift
public static func encode(_ value: any BorshEncodable) throws(BorshEncodingError) -> [UInt8]
```

**Parameters:**
- `value`: The value to encode. Must conform to `BorshEncodable`.

**Returns:**
An array of `UInt8` representing the encoded binary data.

**Throws:**
- `BorshEncodingError.unsupportedType`: If the type cannot be encoded
- `BorshEncodingError.invalidValue`: If the value is invalid

**Example:**
```swift
@BorshCodable
struct Message {
    let text: String
    let timestamp: Int64
}

let message = Message(text: "Hello", timestamp: 1234567890)
let bytes = try BorshEncoder.encode(message)
// bytes: [5, 0, 0, 0, 72, 101, 108, 108, 111, 210, 2, 150, 73, 0, 0, 0, 0]
```

---

### BorshDecoder

Static decoder for converting byte sequences to `BorshDecodable` values.

```swift
public enum BorshDecoder {
    public static func decode<T: BorshDecodable, Bytes: Sequence>(
        _ data: Bytes,
        into: T.Type
    ) throws(BorshDecodingError) -> T where Bytes.Element == UInt8
}
```

#### Methods

##### `decode(_:into:)`

Decodes a byte sequence into a value of the specified type.

**Declaration:**
```swift
public static func decode<T: BorshDecodable, Bytes: Sequence>(
    _ data: Bytes,
    into: T.Type
) throws(BorshDecodingError) -> T where Bytes.Element == UInt8
```

**Generic Parameters:**
- `T`: The type to decode into. Must conform to `BorshDecodable`.
- `Bytes`: A sequence type whose elements are `UInt8`.

**Parameters:**
- `data`: The byte sequence to decode from
- `into`: The type to decode into (e.g., `Message.self`)

**Returns:**
An instance of type `T` decoded from the byte data.

**Throws:**
- `BorshDecodingError.endOfBuffer`: If there's not enough data
- `BorshDecodingError.invalidValue`: If an invalid value is encountered

**Example:**
```swift
@BorshCodable
struct Message {
    let text: String
    let timestamp: Int64
}

let bytes: [UInt8] = [5, 0, 0, 0, 72, 101, 108, 108, 111, 210, 2, 150, 73, 0, 0, 0, 0]
let message = try BorshDecoder.decode(bytes, into: Message.self)
// message.text: "Hello"
// message.timestamp: 1234567890
```

## Error Types

### BorshEncodingError

Errors that can occur during encoding.

```swift
public enum BorshEncodingError: Error, CustomStringConvertible {
    case unsupportedType(any Any.Type)
    case invalidValue
}
```

#### Cases

##### `unsupportedType(_:)`

The type cannot be encoded to Borsh format.

**Associated Value:**
- `Any.Type`: The type that cannot be encoded

**Example:**
```swift
catch BorshEncodingError.unsupportedType(let type) {
    print("Cannot encode type: \(type)")
}
```

##### `invalidValue`

The value is invalid for Borsh encoding.

**Example:**
```swift
catch BorshEncodingError.invalidValue {
    print("Invalid value for encoding")
}
```

---

### BorshDecodingError

Errors that can occur during decoding.

```swift
public enum BorshDecodingError: Error, CustomStringConvertible {
    case endOfBuffer
    case invalidValue
}
```

#### Cases

##### `endOfBuffer`

Reached the end of the buffer unexpectedly while decoding.

This typically means the input data is truncated or corrupted.

**Example:**
```swift
catch BorshDecodingError.endOfBuffer {
    print("Incomplete data: unexpected end of buffer")
}
```

##### `invalidValue`

An invalid value was encountered during decoding.

This could mean corrupted data or a version mismatch.

**Example:**
```swift
catch BorshDecodingError.invalidValue {
    print("Data contains invalid value")
}
```

## Type Extensions

SwiftBorsh provides `BorshCodable` conformance for many standard Swift types.

### Primitive Types

The following types have built-in conformance:

- `Bool`
- `Int8`, `Int16`, `Int32`, `Int64`
- `UInt8`, `UInt16`, `UInt32`, `UInt64`
- `Int128`, `UInt128` (on supported platforms)
- `Float` (Float32)
- `Double` (Float64)
- `String`

**Example:**
```swift
let number: UInt32 = 42
let encoded = try BorshEncoder.encode(number)
let decoded = try BorshDecoder.decode(encoded, into: UInt32.self)
```

### Collection Types

#### Array

Arrays of `BorshCodable` elements are automatically `BorshCodable`.

**Format:** Length (u32) followed by elements

**Example:**
```swift
let numbers = [1, 2, 3, 4, 5]
let encoded = try BorshEncoder.encode(numbers)
let decoded = try BorshDecoder.decode(encoded, into: [Int32].self)
```

#### Set

Sets of `BorshCodable & Hashable` elements are automatically `BorshCodable`.

**Format:** Length (u32) followed by elements (order may vary)

**Example:**
```swift
let tags: Set<String> = ["swift", "borsh", "serialization"]
let encoded = try BorshEncoder.encode(tags)
let decoded = try BorshDecoder.decode(encoded, into: Set<String>.self)
```

#### Dictionary

Dictionaries with `BorshCodable & Hashable` keys and `BorshCodable` values are automatically `BorshCodable`.

**Format:** Length (u32) followed by key-value pairs (order may vary)

**Example:**
```swift
let scores: [String: Int32] = ["Alice": 100, "Bob": 85]
let encoded = try BorshEncoder.encode(scores)
let decoded = try BorshDecoder.decode(encoded, into: [String: Int32].self)
```

### Optional Types

Optional values of `BorshCodable` types are automatically `BorshCodable`.

**Format:** Boolean (1 byte) indicating presence, followed by value if present

**Example:**
```swift
let some: String? = "Hello"
let none: String? = nil

let encodedSome = try BorshEncoder.encode(some)
// [1, 5, 0, 0, 0, 72, 101, 108, 108, 111]
//  ^-- 1 = some
//     ^-- length and string data

let encodedNone = try BorshEncoder.encode(none)
// [0]
//  ^-- 0 = none
```

### Result Type

`Result<Success, Failure>` where both types are `BorshCodable` is automatically `BorshCodable`.

**Format:** Variant index (u8) followed by the value

**Example:**
```swift
@BorshCodable
enum AppError: Error {
    case networkError(code: Int32)
}

let success: Result<String, AppError> = .success("OK")
let failure: Result<String, AppError> = .failure(.networkError(code: 500))

let encodedSuccess = try BorshEncoder.encode(success)
let encodedFailure = try BorshEncoder.encode(failure)
```

### InlineArray (Platform-Specific)

Fixed-size arrays available on iOS 26+, macOS 26+, tvOS 26+, watchOS 26+.

**Format:** Elements in order (no length prefix)

**Example:**
```swift
@available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
let array: InlineArray<3, Int32> = [1, 2, 3]
let encoded = try BorshEncoder.encode(array)
let decoded = try BorshDecoder.decode(encoded, into: InlineArray<3, Int32>.self)
```

## Buffer Type

### BorshByteBuffer

Type alias for the underlying byte buffer used for encoding/decoding.

```swift
public typealias BorshByteBuffer = ByteBuffer
```

The `ByteBuffer` type provides efficient byte manipulation capabilities. You typically don't interact with this directly unless implementing custom `BorshEncodable`/`BorshDecodable` conformance.

**Common Operations:**

```swift
// Create a buffer
var buffer = BorshByteBuffer()

// Write data
try value.borshEncode(to: &buffer)

// Read data
let decoded = try Type(fromBorshBuffer: &buffer)

// Check readable bytes
let available = buffer.readableBytes
```

## Binary Format Details

### Encoding Rules

SwiftBorsh follows the [Borsh specification](https://borsh.io/) for binary encoding:

1. **Integers**: Little-endian byte order
   - `UInt8`: 1 byte
   - `UInt16`: 2 bytes
   - `UInt32`: 4 bytes
   - `UInt64`: 8 bytes
   - Signed integers use two's complement

2. **Floating Point**: IEEE 754, little-endian
   - `Float`: 4 bytes (IEEE 754 single precision)
   - `Double`: 8 bytes (IEEE 754 double precision)

3. **Boolean**: 1 byte
   - `false`: 0x00
   - `true`: 0x01

4. **Strings**: UTF-8 encoded
   - Format: Length (u32) + UTF-8 bytes
   - Length is the byte count, not character count

5. **Collections**: Length-prefixed
   - Format: Length (u32) + elements

6. **Optionals**: Tagged union
   - Format: Tag (u8) + value if present
   - None: 0x00
   - Some: 0x01 + encoded value

7. **Enums**: Variant index + associated data
   - Format: Variant (u8) + associated values
   - Variant index starts at 0

8. **Structs**: Fields in declaration order
   - No length prefix or tags
   - Fields encoded sequentially

### Example Encodings

```swift
// UInt32: 42
[42, 0, 0, 0]

// String: "Hi"
[2, 0, 0, 0, 72, 105]

// Array: [1, 2]
[2, 0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0]

// Optional<UInt32>: .some(42)
[1, 42, 0, 0, 0]

// Optional<UInt32>: .none
[0]
```

## Best Practices

1. **Type Stability**: Once deployed, don't change field order in structs or variant order in enums
2. **Version Compatibility**: Consider using version fields for evolving schemas
3. **Error Handling**: Always handle both encoding and decoding errors appropriately
4. **Buffer Management**: When using custom implementations, ensure proper buffer bounds checking
5. **Testing**: Test round-trip encoding/decoding for your types
6. **Performance**: For hot paths, consider profiling and optimizing custom implementations

## See Also

- [Borsh Specification](https://borsh.io/)
- [SwiftBorsh README](../README.md)
- [Usage Examples](EXAMPLES.md)
