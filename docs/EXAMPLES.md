# Usage Examples

## Basic Types

```swift
import SwiftBorsh

// Primitives
let number: UInt32 = 42
let encoded = try BorshEncoder.encode(number)
let decoded = try BorshDecoder.decode(encoded, into: UInt32.self)

// Strings
let message = "Hello"
let encodedMsg = try BorshEncoder.encode(message)

// Arrays
let numbers = [1, 2, 3, 4, 5]
let encodedArray = try BorshEncoder.encode(numbers)
```

## Structs

```swift
@BorshCodable
struct Point {
    let x: Int32
    let y: Int32
}

let point = Point(x: 10, y: 20)
let encoded = try BorshEncoder.encode(point)
let decoded = try BorshDecoder.decode(encoded, into: Point.self)
```

### Nested Structs

```swift
@BorshCodable
struct Address {
    let street: String
    let city: String
}

@BorshCodable
struct Person {
    let name: String
    let age: UInt8
    let address: Address
}

let person = Person(
    name: "Alice",
    age: 30,
    address: Address(street: "123 Main", city: "NYC")
)
```

## Enums

```swift
@BorshCodable
enum Status {
    case pending
    case active(since: Int64)
    case error(code: Int32, message: String)
}

let status = Status.error(code: 404, message: "Not found")
let encoded = try BorshEncoder.encode(status)
```

## Collections

```swift
// Sets
let tags: Set<String> = ["swift", "borsh"]
let encodedSet = try BorshEncoder.encode(tags)

// Dictionaries
let scores: [String: Int32] = ["Alice": 100, "Bob": 85]
let encodedDict = try BorshEncoder.encode(scores)
```

## Optionals

```swift
@BorshCodable
struct Config {
    let name: String
    let description: String?
    let maxRetries: UInt32?
}

let config = Config(name: "Prod", description: nil, maxRetries: 3)
```

## Blockchain Transaction

```swift
@BorshCodable
struct Transaction {
    let from: String
    let to: String
    let amount: UInt64
    let timestamp: Int64
}

@BorshCodable
struct Block {
    let height: UInt64
    let previousHash: String
    let transactions: [Transaction]
}

let tx = Transaction(
    from: "0x1234",
    to: "0x5678",
    amount: 1000000,
    timestamp: 1234567890
)

let block = Block(
    height: 12345,
    previousHash: "0x0000",
    transactions: [tx]
)

let encoded = try BorshEncoder.encode(block)
```

## Error Handling

```swift
do {
    let encoded = try BorshEncoder.encode(value)
} catch BorshEncodingError.unsupportedType(let type) {
    print("Cannot encode: \(type)")
} catch BorshEncodingError.invalidValue {
    print("Invalid value")
}

do {
    let decoded = try BorshDecoder.decode(bytes, into: Type.self)
} catch BorshDecodingError.endOfBuffer {
    print("Incomplete data")
} catch BorshDecodingError.invalidValue {
    print("Invalid value in data")
}
```

## Result Type

```swift
@BorshCodable
enum AppError: Error {
    case notFound
    case unauthorized(code: Int32)
}

let success: Result<String, AppError> = .success("OK")
let failure: Result<String, AppError> = .failure(.notFound)

let encoded = try BorshEncoder.encode(success)
```

## Custom Implementation

```swift
struct CustomDate: BorshCodable {
    let timestamp: Int64

    func borshEncode(to buffer: inout BorshByteBuffer) throws {
        try timestamp.borshEncode(to: &buffer)
    }

    init(fromBorshBuffer buffer: inout BorshByteBuffer) throws {
        self.timestamp = try Int64(fromBorshBuffer: &buffer)
    }
}
```

## File Persistence

```swift
import Foundation

@BorshCodable
struct Settings {
    let theme: String
    let fontSize: UInt8
    let notifications: Bool
}

func save(_ settings: Settings, to url: URL) throws {
    let encoded = try BorshEncoder.encode(settings)
    try Data(encoded).write(to: url)
}

func load(from url: URL) throws -> Settings {
    let data = try Data(contentsOf: url)
    return try BorshDecoder.decode([UInt8](data), into: Settings.self)
}
```

## Versioned Schema

```swift
@BorshCodable
enum UserData {
    case v1(name: String, age: UInt8)
    case v2(name: String, age: UInt8, email: String)
}

let user = UserData.v2(name: "Alice", age: 30, email: "alice@example.com")
let encoded = try BorshEncoder.encode(user)

// Decoding handles both versions
let decoded = try BorshDecoder.decode(encoded, into: UserData.self)
```

## Generic Wrapper

```swift
@BorshCodable
struct Paginated<T: BorshCodable> {
    let items: [T]
    let page: UInt32
    let totalPages: UInt32
}

@BorshCodable
struct Article {
    let title: String
    let content: String
}

let articles = Paginated(
    items: [Article(title: "Swift", content: "...")],
    page: 1,
    totalPages: 5
)
```

## Best Practices

```swift
// ✅ Always handle errors
do {
    let encoded = try BorshEncoder.encode(value)
} catch {
    print("Error: \(error)")
}

// ✅ Test round-trip
let original = MyStruct(field: "test")
let encoded = try BorshEncoder.encode(original)
let decoded = try BorshDecoder.decode(encoded, into: MyStruct.self)
assert(original == decoded)

// ✅ Use type-safe wrappers
@BorshCodable
struct UserId {
    let value: String
}
```
