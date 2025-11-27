# SwiftBorsh

![Swift](https://img.shields.io/badge/Swift-6.2-orange.svg)
![Platforms](https://img.shields.io/badge/platforms-macOS%20%7C%20iOS%20%7C%20tvOS%20%7C%20watchOS-lightgrey.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

A high-performance Swift implementation of [**B**inary **O**bject **R**epresentation **S**erializer for **H**ashing (Borsh)](https://borsh.io/), a binary serialization format designed for security-critical projects.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Usage](#usage)
  - [Basic Types](#basic-types)
  - [Structs and Enums](#structs-and-enums)
  - [Collections](#collections)
  - [Optionals](#optionals)
  - [Advanced Types](#advanced-types)
- [API Reference](#api-reference)
- [Supported Types](#supported-types)
- [Known Limitations](#known-limitations)
- [Performance](#performance)
- [Contributing](#contributing)
- [License](#license)

## Overview

SwiftBorsh provides a native Swift implementation of the Borsh serialization format, which is widely used in blockchain applications and other security-critical systems. Borsh is designed to be:

- **Deterministic**: The same object always serializes to the same bytes
- **Fast**: Minimal overhead and optimal performance
- **Secure**: Protection against buffer overruns and other common vulnerabilities
- **Strict**: Well-defined schema with no implicit conversions

This library leverages Swift's powerful macro system to provide automatic conformance to Borsh protocols with zero boilerplate code.

## Features

- ✨ **Swift Macros**: Automatic protocol conformance using `@BorshEncodable`, `@BorshDecodable`, and `@BorshCodable` macros
- 🚀 **High Performance**: Efficient binary serialization with minimal copying
- 📦 **Comprehensive Type Support**: Works with structs, enums, tuples, collections, and more
- 🔒 **Type-Safe**: Leverages Swift's type system for compile-time safety
- 🎯 **Zero Dependencies**: Core library has no external dependencies (except ByteBuffer utilities)
- 🧪 **Well Tested**: Comprehensive test coverage
- 🔄 **Bidirectional**: Full encoding and decoding support

## Requirements

- Swift 6.2 or later
- Xcode 16.0 or later (for development)
- Platforms:
  - macOS 10.15+
  - iOS 13.0+
  - tvOS 13.0+
  - watchOS 6.0+
  - macCatalyst 13.0+

## Installation

### Swift Package Manager

Add SwiftBorsh to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/The-SolShare-Team/SwiftBorsh.git", from: "1.0.0")
]
```

Then add it to your target dependencies:

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["SwiftBorsh"]
    )
]
```

### Xcode

1. In Xcode, select **File → Add Package Dependencies...**
2. Enter the repository URL: `https://github.com/The-SolShare-Team/SwiftBorsh.git`
3. Select the version you want to use
4. Click **Add Package**

## Quick Start

```swift
import SwiftBorsh

// Define your data structure with the @BorshCodable macro
@BorshCodable
struct Person {
    let name: String
    let age: UInt32
    let email: String?
}

// Create an instance
let person = Person(name: "Alice", age: 30, email: "alice@example.com")

// Encode to bytes
let encoded = try BorshEncoder.encode(person)
print(encoded) // [5, 0, 0, 0, 65, 108, 105, 99, 101, ...]

// Decode from bytes
let decoded = try BorshDecoder.decode(encoded, into: Person.self)
print(decoded.name) // "Alice"
print(decoded.age)  // 30
```

## Usage

### Basic Types

SwiftBorsh supports all standard Swift numeric types, strings, and booleans:

```swift
import SwiftBorsh

// Integers
let int8: Int8 = 42
let uint32: UInt32 = 12345
let encoded = try BorshEncoder.encode(uint32)

// Floating point
let float: Float = 3.14
let double: Double = 2.718
let encodedFloat = try BorshEncoder.encode(float)

// Strings
let message = "Hello, Borsh!"
let encodedString = try BorshEncoder.encode(message)

// Booleans
let flag = true
let encodedBool = try BorshEncoder.encode(flag)
```

### Structs and Enums

Use the `@BorshCodable` macro for automatic conformance:

```swift
// Simple struct
@BorshCodable
struct Point {
    let x: Int32
    let y: Int32
}

// Struct with various types
@BorshCodable
struct User {
    let id: String
    let username: String
    let age: UInt8
    let isActive: Bool
    let score: Float
}

// Enum with associated values
@BorshCodable
enum Status {
    case pending
    case active(since: Int64)
    case completed(result: String, code: Int32)
}

// Usage
let user = User(
    id: "user123",
    username: "alice",
    age: 30,
    isActive: true,
    score: 95.5
)

let encoded = try BorshEncoder.encode(user)
let decoded = try BorshDecoder.decode(encoded, into: User.self)
```

### Collections

SwiftBorsh supports arrays, sets, and dictionaries:

```swift
// Arrays
let numbers = [1, 2, 3, 4, 5]
let encodedArray = try BorshEncoder.encode(numbers)

// Sets
let uniqueNames: Set<String> = ["Alice", "Bob", "Charlie"]
let encodedSet = try BorshEncoder.encode(uniqueNames)

// Dictionaries
let scores: [String: Int32] = ["Alice": 100, "Bob": 85]
let encodedDict = try BorshEncoder.encode(scores)

// Nested collections
@BorshCodable
struct Config {
    let tags: [String]
    let metadata: [String: String]
    let scores: [Float]
}
```

### Optionals

Optionals are automatically supported:

```swift
@BorshCodable
struct Profile {
    let username: String
    let email: String?      // Optional email
    let bio: String?        // Optional bio
    let age: UInt8
}

// With values
let profile1 = Profile(
    username: "alice",
    email: "alice@example.com",
    bio: "Software developer",
    age: 30
)

// With nil values
let profile2 = Profile(
    username: "bob",
    email: nil,
    bio: nil,
    age: 25
)

let encoded1 = try BorshEncoder.encode(profile1)
let encoded2 = try BorshEncoder.encode(profile2)
```

### Advanced Types

#### Tuples

Tuples are supported in struct properties:

```swift
@BorshCodable
struct Location {
    let name: String
    let coordinates: (latitude: Double, longitude: Double)
    let elevation: Int32
}

let location = Location(
    name: "Mount Everest",
    coordinates: (27.9881, 86.9250),
    elevation: 8848
)
```

#### Result Type

The Swift `Result` type is supported:

```swift
@BorshCodable
enum APIError: Error {
    case notFound
    case unauthorized(code: Int32)
}

let success: Result<String, APIError> = .success("Data loaded")
let failure: Result<String, APIError> = .failure(.unauthorized(code: 401))

let encodedSuccess = try BorshEncoder.encode(success)
let encodedFailure = try BorshEncoder.encode(failure)
```

#### InlineArray (iOS 26+)

For fixed-size arrays on supported platforms:

```swift
@available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
let fixedArray: InlineArray<3, String> = ["Alpha", "Beta", "Gamma"]
let encoded = try BorshEncoder.encode(fixedArray)
let decoded = try BorshDecoder.decode(encoded, into: InlineArray<3, String>.self)
```

#### Manual Conformance

For custom encoding/decoding logic, implement the protocols manually:

```swift
struct CustomType: BorshCodable {
    let value: Int32

    // Custom encoding
    func borshEncode(to buffer: inout BorshByteBuffer) throws(BorshEncodingError) {
        try value.borshEncode(to: &buffer)
    }

    // Custom decoding
    init(fromBorshBuffer buffer: inout BorshByteBuffer) throws(BorshDecodingError) {
        self.value = try Int32(fromBorshBuffer: &buffer)
    }
}
```

## API Reference

### Macros

#### `@BorshEncodable`
Automatically implements the `BorshEncodable` protocol for encoding types to Borsh format.

```swift
@BorshEncodable
struct MyStruct {
    let field1: String
    let field2: Int32
}
```

#### `@BorshDecodable`
Automatically implements the `BorshDecodable` protocol for decoding types from Borsh format.

```swift
@BorshDecodable
struct MyStruct {
    let field1: String
    let field2: Int32
}
```

#### `@BorshCodable`
Combines both `@BorshEncodable` and `@BorshDecodable` for full bidirectional serialization.

```swift
@BorshCodable
struct MyStruct {
    let field1: String
    let field2: Int32
}
```

### Protocols

#### `BorshEncodable`
Protocol for types that can be encoded to Borsh format.

```swift
public protocol BorshEncodable {
    func borshEncode(to buffer: inout BorshByteBuffer) throws(BorshEncodingError)
}
```

#### `BorshDecodable`
Protocol for types that can be decoded from Borsh format.

```swift
public protocol BorshDecodable {
    init(fromBorshBuffer buffer: inout BorshByteBuffer) throws(BorshDecodingError)
}
```

#### `BorshCodable`
Combined protocol for types that support both encoding and decoding.

```swift
public protocol BorshCodable: BorshEncodable, BorshDecodable {}
```

### Encoder

#### `BorshEncoder.encode(_:)`
Encodes a `BorshEncodable` value to a byte array.

```swift
public static func encode(_ value: any BorshEncodable) throws(BorshEncodingError) -> [UInt8]
```

**Parameters:**
- `value`: The value to encode

**Returns:** An array of bytes representing the encoded value

**Throws:** `BorshEncodingError` if encoding fails

**Example:**
```swift
let person = Person(name: "Alice", age: 30)
let bytes = try BorshEncoder.encode(person)
```

### Decoder

#### `BorshDecoder.decode(_:into:)`
Decodes a byte sequence into a `BorshDecodable` type.

```swift
public static func decode<T: BorshDecodable, Bytes: Sequence>(
    _ data: Bytes,
    into: T.Type
) throws(BorshDecodingError) -> T where Bytes.Element == UInt8
```

**Parameters:**
- `data`: The byte sequence to decode
- `into`: The type to decode into

**Returns:** An instance of the decoded type

**Throws:** `BorshDecodingError` if decoding fails

**Example:**
```swift
let bytes: [UInt8] = [6, 0, 0, 0, 65, 108, 105, 99, 101, ...]
let person = try BorshDecoder.decode(bytes, into: Person.self)
```

### Errors

#### `BorshEncodingError`
Errors that can occur during encoding.

```swift
public enum BorshEncodingError: Error {
    case unsupportedType(any Any.Type)  // Type cannot be encoded
    case invalidValue                    // Value is invalid for encoding
}
```

#### `BorshDecodingError`
Errors that can occur during decoding.

```swift
public enum BorshDecodingError: Error {
    case endOfBuffer    // Unexpected end of input buffer
    case invalidValue   // Invalid value encountered
}
```

## Supported Types

### Primitive Types
- ✅ `Bool`
- ✅ `Int8`, `Int16`, `Int32`, `Int64`
- ✅ `UInt8`, `UInt16`, `UInt32`, `UInt64`
- ✅ `Float`, `Double`
- ✅ `String`

### Special Integer Types
- ✅ `Int128` / `UInt128` (on supported platforms)

### Collection Types
- ✅ `Array<T>` where `T: BorshCodable`
- ✅ `Set<T>` where `T: BorshCodable & Hashable`
- ✅ `Dictionary<K, V>` where `K: BorshCodable & Hashable, V: BorshCodable`
- ✅ `InlineArray<N, T>` where `T: BorshCodable` (iOS 26+)

### Optional Types
- ✅ `Optional<T>` where `T: BorshCodable`

### Composite Types
- ✅ Custom structs (with `@BorshCodable` macro)
- ✅ Enums with associated values (with `@BorshCodable` macro)
- ✅ Tuples (when used as struct properties)
- ✅ `Result<Success, Failure>` where both are `BorshCodable`

## Known Limitations

- **Nested Tuples**: Complex nested tuple structures are currently not fully supported by the macros. Simple tuples work fine.
- **Performance**: There is room for optimization, particularly in reducing memory copies during serialization/deserialization.
- **InlineArray**: Only available on iOS 26.0+, macOS 26.0+, tvOS 26.0+, watchOS 26.0+ and later.

## Performance

SwiftBorsh is designed for performance, but there are opportunities for optimization:

- **Current Focus**: Correctness and API stability
- **Future Work**: Reducing memory copies and optimizing hot paths
- **Benchmarking**: Performance benchmarks coming soon

For production use cases, always profile your specific workload.

## Example: Complete Application

```swift
import SwiftBorsh

// Define your domain models
@BorshCodable
struct Transaction {
    let id: String
    let from: String
    let to: String
    let amount: UInt64
    let timestamp: Int64
    let memo: String?
}

@BorshCodable
enum TransactionStatus {
    case pending
    case confirmed(blockHeight: UInt64)
    case failed(reason: String)
}

@BorshCodable
struct Block {
    let height: UInt64
    let hash: String
    let transactions: [Transaction]
    let timestamp: Int64
}

// Usage
func processBlock(_ block: Block) throws {
    // Serialize block
    let encoded = try BorshEncoder.encode(block)

    // Send over network, save to disk, etc.
    saveToDatabase(encoded)

    // Later, deserialize
    let retrieved = loadFromDatabase()
    let decoded = try BorshDecoder.decode(retrieved, into: Block.self)

    print("Block \(decoded.height) has \(decoded.transactions.count) transactions")
}
```

## Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

### Areas for Contribution

- Performance optimizations
- Additional type support
- Documentation improvements
- Test coverage
- Bug fixes

### Known Issues

- Nested tuples are not fully supported by macros (please report specific cases)
- Performance optimization opportunities exist

Please report any types for which the macros do not generate correct implementations.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Resources

- [Borsh Specification](https://borsh.io/)
- [Swift Macros Documentation](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/macros/)
- [Swift Package Manager](https://swift.org/package-manager/)

## Acknowledgments

This library uses the ByteBuffer utilities for efficient byte manipulation and is built on Swift's powerful macro system introduced in Swift 5.9+.
