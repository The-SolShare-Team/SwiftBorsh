# SwiftBorsh Usage Examples

Comprehensive examples demonstrating various use cases for SwiftBorsh.

## Table of Contents

- [Basic Examples](#basic-examples)
- [Working with Structs](#working-with-structs)
- [Working with Enums](#working-with-enums)
- [Collections and Optionals](#collections-and-optionals)
- [Real-World Examples](#real-world-examples)
- [Error Handling](#error-handling)
- [Advanced Patterns](#advanced-patterns)
- [Integration Examples](#integration-examples)

## Basic Examples

### Encoding and Decoding Primitives

```swift
import SwiftBorsh

// Integers
let number: UInt32 = 42
let encodedNumber = try BorshEncoder.encode(number)
print(encodedNumber) // [42, 0, 0, 0]

let decodedNumber = try BorshDecoder.decode(encodedNumber, into: UInt32.self)
print(decodedNumber) // 42

// Strings
let message = "Hello, Borsh!"
let encodedMessage = try BorshEncoder.encode(message)

let decodedMessage = try BorshDecoder.decode(encodedMessage, into: String.self)
print(decodedMessage) // "Hello, Borsh!"

// Booleans
let flag = true
let encodedFlag = try BorshEncoder.encode(flag)
print(encodedFlag) // [1]

// Floating point
let pi: Float = 3.14159
let encodedPi = try BorshEncoder.encode(pi)
let decodedPi = try BorshDecoder.decode(encodedPi, into: Float.self)
```

### Working with Arrays

```swift
// Array of integers
let numbers = [1, 2, 3, 4, 5]
let encoded = try BorshEncoder.encode(numbers)
let decoded = try BorshDecoder.decode(encoded, into: [Int32].self)

// Array of strings
let names = ["Alice", "Bob", "Charlie"]
let encodedNames = try BorshEncoder.encode(names)
let decodedNames = try BorshDecoder.decode(encodedNames, into: [String].self)

// Empty array
let empty: [UInt32] = []
let encodedEmpty = try BorshEncoder.encode(empty)
// encodedEmpty: [0, 0, 0, 0] (just the length prefix)
```

## Working with Structs

### Simple Struct

```swift
import SwiftBorsh

@BorshCodable
struct Point {
    let x: Int32
    let y: Int32
}

let point = Point(x: 10, y: 20)
let encoded = try BorshEncoder.encode(point)
// encoded: [10, 0, 0, 0, 20, 0, 0, 0]

let decoded = try BorshDecoder.decode(encoded, into: Point.self)
print(decoded.x) // 10
print(decoded.y) // 20
```

### Nested Structs

```swift
@BorshCodable
struct Address {
    let street: String
    let city: String
    let zipCode: String
}

@BorshCodable
struct Person {
    let name: String
    let age: UInt8
    let address: Address
}

let address = Address(
    street: "123 Main St",
    city: "Springfield",
    zipCode: "12345"
)

let person = Person(
    name: "Alice",
    age: 30,
    address: address
)

let encoded = try BorshEncoder.encode(person)
let decoded = try BorshDecoder.decode(encoded, into: Person.self)

print(decoded.name) // "Alice"
print(decoded.address.city) // "Springfield"
```

### Struct with Mixed Types

```swift
@BorshCodable
struct UserProfile {
    let id: String
    let username: String
    let age: UInt8
    let score: Float
    let isActive: Bool
    let tags: [String]
    let metadata: [String: String]
}

let profile = UserProfile(
    id: "user123",
    username: "alice_dev",
    age: 30,
    score: 95.5,
    isActive: true,
    tags: ["swift", "developer", "ios"],
    metadata: ["role": "engineer", "level": "senior"]
)

let encoded = try BorshEncoder.encode(profile)
let decoded = try BorshDecoder.decode(encoded, into: UserProfile.self)
```

### Struct with Tuples

```swift
@BorshCodable
struct Rectangle {
    let topLeft: (x: Int32, y: Int32)
    let bottomRight: (x: Int32, y: Int32)
}

let rect = Rectangle(
    topLeft: (x: 0, y: 0),
    bottomRight: (x: 100, y: 50)
)

let encoded = try BorshEncoder.encode(rect)
let decoded = try BorshDecoder.decode(encoded, into: Rectangle.self)
```

## Working with Enums

### Simple Enum

```swift
@BorshCodable
enum Status {
    case pending
    case active
    case completed
    case cancelled
}

let status = Status.active
let encoded = try BorshEncoder.encode(status)
// encoded: [1] (variant index)

let decoded = try BorshDecoder.decode(encoded, into: Status.self)
```

### Enum with Associated Values

```swift
@BorshCodable
enum ServerResponse {
    case success(data: String)
    case error(code: Int32, message: String)
    case loading
}

let response = ServerResponse.error(code: 404, message: "Not found")
let encoded = try BorshEncoder.encode(response)
let decoded = try BorshDecoder.decode(encoded, into: ServerResponse.self)

// Pattern matching
switch decoded {
case .success(let data):
    print("Success: \(data)")
case .error(let code, let message):
    print("Error \(code): \(message)")
case .loading:
    print("Loading...")
}
```

### Complex Enum with Multiple Associated Values

```swift
@BorshCodable
enum Transaction {
    case transfer(from: String, to: String, amount: UInt64)
    case mint(account: String, amount: UInt64)
    case burn(account: String, amount: UInt64)
    case approve(owner: String, spender: String, amount: UInt64)
}

let tx = Transaction.transfer(
    from: "alice",
    to: "bob",
    amount: 1000
)

let encoded = try BorshEncoder.encode(tx)
let decoded = try BorshDecoder.decode(encoded, into: Transaction.self)
```

### Nested Enums

```swift
@BorshCodable
enum NetworkError {
    case timeout
    case invalidResponse
}

@BorshCodable
enum AppError {
    case network(NetworkError)
    case validation(message: String)
    case unknown
}

let error = AppError.network(.timeout)
let encoded = try BorshEncoder.encode(error)
let decoded = try BorshDecoder.decode(encoded, into: AppError.self)
```

## Collections and Optionals

### Working with Optionals

```swift
@BorshCodable
struct Config {
    let name: String
    let description: String?
    let maxRetries: UInt32?
}

// With some values
let config1 = Config(
    name: "Production",
    description: "Production environment",
    maxRetries: 3
)

// With nil values
let config2 = Config(
    name: "Test",
    description: nil,
    maxRetries: nil
)

let encoded1 = try BorshEncoder.encode(config1)
let encoded2 = try BorshEncoder.encode(config2)

let decoded1 = try BorshDecoder.decode(encoded1, into: Config.self)
let decoded2 = try BorshDecoder.decode(encoded2, into: Config.self)
```

### Working with Sets

```swift
let uniqueTags: Set<String> = ["swift", "rust", "python"]
let encoded = try BorshEncoder.encode(uniqueTags)
let decoded = try BorshDecoder.decode(encoded, into: Set<String>.self)

print(decoded.count) // 3
print(decoded.contains("swift")) // true
```

### Working with Dictionaries

```swift
let scores: [String: Int32] = [
    "Alice": 100,
    "Bob": 85,
    "Charlie": 92
]

let encoded = try BorshEncoder.encode(scores)
let decoded = try BorshDecoder.decode(encoded, into: [String: Int32].self)

print(decoded["Alice"]) // Optional(100)
```

### Nested Collections

```swift
@BorshCodable
struct DataAnalysis {
    let samples: [[Double]]
    let labels: [String]
    let metadata: [String: [String]]
}

let analysis = DataAnalysis(
    samples: [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]],
    labels: ["Sample A", "Sample B"],
    metadata: ["tags": ["experiment", "2024"], "authors": ["Alice", "Bob"]]
)

let encoded = try BorshEncoder.encode(analysis)
let decoded = try BorshDecoder.decode(encoded, into: DataAnalysis.self)
```

## Real-World Examples

### Blockchain Transaction

```swift
import SwiftBorsh

@BorshCodable
struct Transaction {
    let from: String
    let to: String
    let amount: UInt64
    let nonce: UInt64
    let timestamp: Int64
    let signature: String?
}

@BorshCodable
struct Block {
    let height: UInt64
    let previousHash: String
    let timestamp: Int64
    let transactions: [Transaction]
    let minerAddress: String
}

// Create transactions
let tx1 = Transaction(
    from: "0x1234...",
    to: "0x5678...",
    amount: 1000000,
    nonce: 1,
    timestamp: 1234567890,
    signature: "sig123..."
)

let tx2 = Transaction(
    from: "0xabcd...",
    to: "0xef01...",
    amount: 500000,
    nonce: 2,
    timestamp: 1234567891,
    signature: "sig456..."
)

// Create block
let block = Block(
    height: 12345,
    previousHash: "0x0000...",
    timestamp: 1234567890,
    transactions: [tx1, tx2],
    minerAddress: "0xminer..."
)

// Serialize for network transmission
let encodedBlock = try BorshEncoder.encode(block)

// Later, deserialize
let receivedBlock = try BorshDecoder.decode(encodedBlock, into: Block.self)
print("Block \(receivedBlock.height) has \(receivedBlock.transactions.count) transactions")
```

### API Request/Response

```swift
@BorshCodable
struct APIRequest {
    let endpoint: String
    let method: String
    let headers: [String: String]
    let body: String?
}

@BorshCodable
enum APIResponse {
    case success(statusCode: Int32, body: String)
    case error(statusCode: Int32, message: String)
}

// Create request
let request = APIRequest(
    endpoint: "/api/users",
    method: "POST",
    headers: ["Content-Type": "application/json"],
    body: "{\"name\": \"Alice\"}"
)

// Serialize for transmission
let encodedRequest = try BorshEncoder.encode(request)

// Process response
let response = APIResponse.success(
    statusCode: 200,
    body: "{\"id\": \"123\", \"name\": \"Alice\"}"
)

let encodedResponse = try BorshEncoder.encode(response)
```

### Game State Serialization

```swift
@BorshCodable
struct Vector3 {
    let x: Float
    let y: Float
    let z: Float
}

@BorshCodable
struct Player {
    let id: String
    let name: String
    let position: Vector3
    let health: Int32
    let score: Int64
    let inventory: [String]
}

@BorshCodable
struct GameState {
    let level: UInt32
    let players: [Player]
    let timestamp: Int64
    let isActive: Bool
}

let player1 = Player(
    id: "player1",
    name: "Alice",
    position: Vector3(x: 10.5, y: 0.0, z: 5.2),
    health: 100,
    score: 1500,
    inventory: ["sword", "shield", "potion"]
)

let gameState = GameState(
    level: 5,
    players: [player1],
    timestamp: 1234567890,
    isActive: true
)

// Save game state
let savedState = try BorshEncoder.encode(gameState)

// Later, load game state
let loadedState = try BorshDecoder.decode(savedState, into: GameState.self)
```

### Configuration Management

```swift
@BorshCodable
struct DatabaseConfig {
    let host: String
    let port: UInt16
    let username: String
    let password: String?
    let database: String
    let maxConnections: UInt32
}

@BorshCodable
struct ServerConfig {
    let serverName: String
    let port: UInt16
    let enableSSL: Bool
    let database: DatabaseConfig
    let features: Set<String>
}

let config = ServerConfig(
    serverName: "production-server",
    port: 8080,
    enableSSL: true,
    database: DatabaseConfig(
        host: "db.example.com",
        port: 5432,
        username: "admin",
        password: nil,
        database: "myapp",
        maxConnections: 100
    ),
    features: ["auth", "api", "websockets"]
)

// Serialize configuration
let encodedConfig = try BorshEncoder.encode(config)

// Save to file or transmit
// Later, load configuration
let loadedConfig = try BorshDecoder.decode(encodedConfig, into: ServerConfig.self)
```

## Error Handling

### Basic Error Handling

```swift
import SwiftBorsh

@BorshCodable
struct User {
    let name: String
    let age: UInt8
}

// Encoding with error handling
do {
    let user = User(name: "Alice", age: 30)
    let encoded = try BorshEncoder.encode(user)
    print("Encoded successfully: \(encoded.count) bytes")
} catch BorshEncodingError.unsupportedType(let type) {
    print("Cannot encode type: \(type)")
} catch BorshEncodingError.invalidValue {
    print("Invalid value encountered")
} catch {
    print("Unexpected error: \(error)")
}

// Decoding with error handling
let bytes: [UInt8] = [5, 0, 0, 0, 65, 108, 105, 99, 101, 30]

do {
    let user = try BorshDecoder.decode(bytes, into: User.self)
    print("Decoded: \(user.name), age \(user.age)")
} catch BorshDecodingError.endOfBuffer {
    print("Incomplete data: unexpected end of buffer")
} catch BorshDecodingError.invalidValue {
    print("Data contains invalid value")
} catch {
    print("Unexpected error: \(error)")
}
```

### Graceful Degradation

```swift
@BorshCodable
struct Message {
    let id: String
    let content: String
    let metadata: [String: String]?
}

func loadMessage(from data: [UInt8]) -> Message? {
    do {
        return try BorshDecoder.decode(data, into: Message.self)
    } catch {
        print("Failed to decode message: \(error)")
        return nil
    }
}

// Usage
if let message = loadMessage(from: someBytes) {
    print("Loaded: \(message.content)")
} else {
    print("Using default message")
}
```

### Result Type for Error Handling

```swift
@BorshCodable
enum DataError: Error {
    case notFound
    case invalidFormat
    case permissionDenied
}

func fetchData() -> Result<String, DataError> {
    // Simulate fetch operation
    return .success("Data loaded successfully")
}

let result = fetchData()
let encoded = try BorshEncoder.encode(result)
let decoded = try BorshDecoder.decode(encoded, into: Result<String, DataError>.self)

switch decoded {
case .success(let data):
    print("Success: \(data)")
case .failure(let error):
    print("Error: \(error)")
}
```

## Advanced Patterns

### Custom Encoding/Decoding

```swift
import SwiftBorsh

struct CustomDate: BorshCodable {
    let timestamp: Int64

    // Custom encoding
    func borshEncode(to buffer: inout BorshByteBuffer) throws(BorshEncodingError) {
        try timestamp.borshEncode(to: &buffer)
    }

    // Custom decoding
    init(fromBorshBuffer buffer: inout BorshByteBuffer) throws(BorshDecodingError) {
        self.timestamp = try Int64(fromBorshBuffer: &buffer)
    }

    // Convenience initializer
    init(date: Date) {
        self.timestamp = Int64(date.timeIntervalSince1970)
    }

    var date: Date {
        Date(timeIntervalSince1970: TimeInterval(timestamp))
    }
}

// Usage
let customDate = CustomDate(date: Date())
let encoded = try BorshEncoder.encode(customDate)
let decoded = try BorshDecoder.decode(encoded, into: CustomDate.self)
```

### Versioned Schemas

```swift
@BorshCodable
enum UserDataV1 {
    case v1(name: String, age: UInt8)
}

@BorshCodable
enum UserDataV2 {
    case v1(name: String, age: UInt8)
    case v2(name: String, age: UInt8, email: String)
}

// Encoding with version
let userData = UserDataV2.v2(name: "Alice", age: 30, email: "alice@example.com")
let encoded = try BorshEncoder.encode(userData)

// Decoding handles both versions
let decoded = try BorshDecoder.decode(encoded, into: UserDataV2.self)

switch decoded {
case .v1(let name, let age):
    print("V1 user: \(name), \(age)")
case .v2(let name, let age, let email):
    print("V2 user: \(name), \(age), \(email)")
}
```

### Generic Wrapper

```swift
@BorshCodable
struct Paginated<T: BorshCodable> {
    let items: [T]
    let page: UInt32
    let totalPages: UInt32
    let totalItems: UInt32
}

@BorshCodable
struct Article {
    let title: String
    let author: String
    let content: String
}

let articles = Paginated(
    items: [
        Article(title: "Swift Tips", author: "Alice", content: "..."),
        Article(title: "Borsh Guide", author: "Bob", content: "...")
    ],
    page: 1,
    totalPages: 5,
    totalItems: 42
)

let encoded = try BorshEncoder.encode(articles)
let decoded = try BorshDecoder.decode(encoded, into: Paginated<Article>.self)
```

## Integration Examples

### Network Communication

```swift
import Foundation
import SwiftBorsh

@BorshCodable
struct NetworkMessage {
    let type: String
    let payload: String
    let timestamp: Int64
}

class NetworkClient {
    func send(_ message: NetworkMessage) async throws {
        let encoded = try BorshEncoder.encode(message)

        // Send over network (pseudo-code)
        let url = URL(string: "https://api.example.com/message")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = Data(encoded)

        let (data, _) = try await URLSession.shared.data(for: request)

        // Decode response
        let response = try BorshDecoder.decode([UInt8](data), into: NetworkMessage.self)
        print("Received: \(response.payload)")
    }
}
```

### File Persistence

```swift
import Foundation
import SwiftBorsh

@BorshCodable
struct AppSettings {
    let theme: String
    let fontSize: UInt8
    let notifications: Bool
    let lastOpened: Int64
}

class SettingsManager {
    let fileURL: URL

    init(filename: String) {
        let documentsPath = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
        self.fileURL = documentsPath.appendingPathComponent(filename)
    }

    func save(_ settings: AppSettings) throws {
        let encoded = try BorshEncoder.encode(settings)
        try Data(encoded).write(to: fileURL)
    }

    func load() throws -> AppSettings {
        let data = try Data(contentsOf: fileURL)
        return try BorshDecoder.decode([UInt8](data), into: AppSettings.self)
    }
}

// Usage
let manager = SettingsManager(filename: "settings.borsh")
let settings = AppSettings(
    theme: "dark",
    fontSize: 14,
    notifications: true,
    lastOpened: Int64(Date().timeIntervalSince1970)
)

try manager.save(settings)
let loaded = try manager.load()
```

### Inter-Process Communication

```swift
import SwiftBorsh

@BorshCodable
enum IPCMessage {
    case request(id: String, action: String, params: [String: String])
    case response(id: String, result: String)
    case error(id: String, message: String)
}

class IPCChannel {
    func sendRequest(action: String, params: [String: String]) async throws -> String {
        let id = UUID().uuidString
        let message = IPCMessage.request(id: id, action: action, params: params)
        let encoded = try BorshEncoder.encode(message)

        // Send through IPC mechanism (pipe, socket, etc.)
        // ...

        // Receive response
        let responseBytes = try await receiveResponse()
        let response = try BorshDecoder.decode(responseBytes, into: IPCMessage.self)

        switch response {
        case .response(_, let result):
            return result
        case .error(_, let message):
            throw NSError(domain: "IPC", code: -1, userInfo: [NSLocalizedDescriptionKey: message])
        default:
            throw NSError(domain: "IPC", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected response"])
        }
    }

    private func receiveResponse() async throws -> [UInt8] {
        // Implementation depends on IPC mechanism
        fatalError("Not implemented")
    }
}
```

### Caching Layer

```swift
import Foundation
import SwiftBorsh

@BorshCodable
struct CacheEntry<T: BorshCodable> {
    let data: T
    let timestamp: Int64
    let expiresAt: Int64
}

class BorshCache {
    private let cacheDirectory: URL

    init() {
        let cachePath = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )[0]
        self.cacheDirectory = cachePath.appendingPathComponent("BorshCache")
        try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }

    func set<T: BorshCodable>(_ value: T, forKey key: String, ttl: TimeInterval = 3600) throws {
        let now = Int64(Date().timeIntervalSince1970)
        let entry = CacheEntry(
            data: value,
            timestamp: now,
            expiresAt: now + Int64(ttl)
        )

        let encoded = try BorshEncoder.encode(entry)
        let fileURL = cacheDirectory.appendingPathComponent(key)
        try Data(encoded).write(to: fileURL)
    }

    func get<T: BorshCodable>(_ key: String, as type: T.Type) throws -> T? {
        let fileURL = cacheDirectory.appendingPathComponent(key)

        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }

        let data = try Data(contentsOf: fileURL)
        let entry = try BorshDecoder.decode([UInt8](data), into: CacheEntry<T>.self)

        let now = Int64(Date().timeIntervalSince1970)
        guard entry.expiresAt > now else {
            // Expired
            try? FileManager.default.removeItem(at: fileURL)
            return nil
        }

        return entry.data
    }
}

// Usage
let cache = BorshCache()

@BorshCodable
struct UserData {
    let id: String
    let name: String
}

let userData = UserData(id: "123", name: "Alice")
try cache.set(userData, forKey: "user_123", ttl: 3600)

if let cached = try cache.get("user_123", as: UserData.self) {
    print("Cached user: \(cached.name)")
}
```

## Best Practices

### 1. Always Handle Errors

```swift
// ❌ Don't do this
let encoded = try! BorshEncoder.encode(value)

// ✅ Do this
do {
    let encoded = try BorshEncoder.encode(value)
    // Use encoded data
} catch {
    // Handle error appropriately
    print("Encoding failed: \(error)")
}
```

### 2. Test Round-Trip Encoding

```swift
func testRoundTrip() {
    let original = MyStruct(field1: "test", field2: 42)
    let encoded = try! BorshEncoder.encode(original)
    let decoded = try! BorshDecoder.decode(encoded, into: MyStruct.self)
    assert(original == decoded)
}
```

### 3. Use Type-Safe Patterns

```swift
// ✅ Good: Type-safe wrapper
@BorshCodable
struct UserId {
    let value: String
}

// ❌ Less safe: Plain string
typealias UserId = String
```

### 4. Document Binary Compatibility

```swift
/// User data structure.
///
/// Binary format (Borsh):
/// - version: u8
/// - id: String (length-prefixed)
/// - name: String (length-prefixed)
/// - created_at: i64
///
/// Version 1 format, do not change field order.
@BorshCodable
struct User {
    let version: UInt8 = 1
    let id: String
    let name: String
    let createdAt: Int64
}
```

## See Also

- [SwiftBorsh README](../README.md)
- [API Reference](API.md)
- [Contributing Guide](CONTRIBUTING.md)
- [Borsh Specification](https://borsh.io/)
