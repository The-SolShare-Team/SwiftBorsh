# SwiftBorsh

Swift implementation of [Borsh](https://borsh.io/) binary serialization.

## Features

- Automatic conformance via Swift macros (`@BorshCodable`)
- Supports structs, enums, collections, optionals, tuples
- Type-safe encoding and decoding
- Zero external dependencies

## Installation

Add to `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/The-SolShare-Team/SwiftBorsh.git", from: "1.0.0")
]
```

## Requirements

- Swift 6.2+
- macOS 10.15+ / iOS 13.0+ / tvOS 13.0+ / watchOS 6.0+

## Quick Start

```swift
import SwiftBorsh

@BorshCodable
struct Person {
    let name: String
    let age: UInt64
    let score: Float
}

let person = Person(name: "Alice", age: 30, score: 95.5)

// Encode
let bytes = try BorshEncoder.encode(person)

// Decode
let decoded = try BorshDecoder.decode(bytes, into: Person.self)
```

## Usage

### Supported Types

**Primitives:** `Bool`, `Int8-64`, `UInt8-64`, `Float`, `Double`, `String`
**Collections:** `Array`, `Set`, `Dictionary`, `Optional`
**Composite:** Structs, enums with associated values, tuples, `Result`, `InlineArray` (iOS 26+)

### Structs

```swift
@BorshCodable
struct User {
    let id: String
    let age: UInt8
    let tags: [String]
    let metadata: [String: Int32]?
}
```

### Enums

```swift
@BorshCodable
enum Status {
    case pending
    case active(since: Int64)
    case error(code: Int32, message: String)
}
```

### Collections

```swift
let numbers = [1, 2, 3, 4, 5]
let encoded = try BorshEncoder.encode(numbers)

let tags: Set<String> = ["swift", "borsh"]
let scores: [String: Int32] = ["Alice": 100]
```

### Manual Conformance

```swift
struct Custom: BorshCodable {
    let value: Int32

    func borshEncode(to buffer: inout BorshByteBuffer) throws(BorshEncodingError) {
        try value.borshEncode(to: &buffer)
    }

    init(fromBorshBuffer buffer: inout BorshByteBuffer) throws(BorshDecodingError) {
        self.value = try Int32(fromBorshBuffer: &buffer)
    }
}
```

## API

### Macros

- `@BorshEncodable` - Generate encoding implementation
- `@BorshDecodable` - Generate decoding implementation
- `@BorshCodable` - Generate both

### Encoder/Decoder

```swift
BorshEncoder.encode(_ value: any BorshEncodable) throws -> [UInt8]
BorshDecoder.decode<T>(_ data: Bytes, into: T.Type) throws -> T
```

### Errors

```swift
enum BorshEncodingError: Error {
    case unsupportedType(any Any.Type)
    case invalidValue
}

enum BorshDecodingError: Error {
    case endOfBuffer
    case invalidValue
}
```

## Limitations

- Nested tuples not fully supported by macros
- Performance optimizations pending (reduce copies)

## Contributing

Contributions welcome! See [CONTRIBUTING.md](docs/CONTRIBUTING.md) for guidelines.

Areas needing help:
- Performance optimization
- Additional type support
- Test coverage

## Resources

- [Borsh Specification](https://borsh.io/)
- [API Reference](docs/API.md)
- [Examples](docs/EXAMPLES.md)

## License

MIT License
