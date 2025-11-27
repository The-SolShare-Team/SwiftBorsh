# API Reference

## Protocols

### BorshEncodable

```swift
protocol BorshEncodable {
    func borshEncode(to buffer: inout BorshByteBuffer) throws(BorshEncodingError)
}
```

Encodes value to Borsh binary format.

### BorshDecodable

```swift
protocol BorshDecodable {
    init(fromBorshBuffer buffer: inout BorshByteBuffer) throws(BorshDecodingError)
}
```

Decodes value from Borsh binary format.

### BorshCodable

```swift
protocol BorshCodable: BorshEncodable, BorshDecodable {}
```

Combined encoding and decoding.

## Macros

### @BorshEncodable

Generates `BorshEncodable` conformance.

```swift
@BorshEncodable
struct User {
    let id: String
    let name: String
}
```

### @BorshDecodable

Generates `BorshDecodable` conformance.

### @BorshCodable

Generates both `BorshEncodable` and `BorshDecodable`.

## Encoder/Decoder

### BorshEncoder

```swift
static func encode(_ value: any BorshEncodable) throws(BorshEncodingError) -> [UInt8]
```

Encodes value to byte array.

**Example:**
```swift
let bytes = try BorshEncoder.encode(person)
```

### BorshDecoder

```swift
static func decode<T: BorshDecodable, Bytes: Sequence>(
    _ data: Bytes,
    into: T.Type
) throws(BorshDecodingError) -> T where Bytes.Element == UInt8
```

Decodes byte sequence to typed value.

**Example:**
```swift
let person = try BorshDecoder.decode(bytes, into: Person.self)
```

## Errors

### BorshEncodingError

```swift
enum BorshEncodingError: Error {
    case unsupportedType(any Any.Type)
    case invalidValue
}
```

### BorshDecodingError

```swift
enum BorshDecodingError: Error {
    case endOfBuffer
    case invalidValue
}
```

## Supported Types

### Primitives
- `Bool`, `Int8-64`, `UInt8-64`, `Float`, `Double`, `String`

### Collections
- `Array<T>` where `T: BorshCodable`
- `Set<T>` where `T: BorshCodable & Hashable`
- `Dictionary<K, V>` where `K: BorshCodable & Hashable, V: BorshCodable`

### Special
- `Optional<T>` where `T: BorshCodable`
- `Result<Success, Failure>` where both are `BorshCodable`
- `InlineArray<N, T>` (iOS 26+, macOS 26+)

## Binary Format

### Integers
Little-endian byte order. Signed integers use two's complement.

### Floats
IEEE 754, little-endian.

### Booleans
1 byte: `false` = 0x00, `true` = 0x01.

### Strings
UTF-8 encoded: `length (u32) + bytes`

### Collections
Length-prefixed: `count (u32) + elements`

### Optionals
Tagged: `tag (u8) + value`
- None: 0x00
- Some: 0x01 + encoded value

### Enums
`variant (u8) + associated values`

### Structs
Fields in declaration order, no prefix.

## Examples

```swift
// UInt32: 42
[42, 0, 0, 0]

// String: "Hi"
[2, 0, 0, 0, 72, 105]

// Optional<UInt32>: .some(42)
[1, 42, 0, 0, 0]

// Optional<UInt32>: .none
[0]
```
