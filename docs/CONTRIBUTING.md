# Contributing

## Setup

```bash
git clone https://github.com/YOUR-USERNAME/SwiftBorsh.git
cd SwiftBorsh
swift build
swift test
```

## Requirements

- Swift 6.2+
- Xcode 16.0+ (for macOS)

## Code Style

- Use 4 spaces for indentation
- CamelCase for types, camelCase for variables/functions
- Add doc comments for public APIs
- Max line length: 100 characters (flexible)

```swift
/// Encodes a value to Borsh format.
public static func encode(_ value: any BorshEncodable) throws -> [UInt8] {
    // implementation
}
```

## Testing

All new code needs tests. Test naming should be descriptive:

```swift
@Test func testEncodingStructWithOptionalFields() {
    let value = TestStruct(required: "test", optional: nil)
    let encoded = try BorshEncoder.encode(value)
    #expect(encoded == expectedBytes)
}
```

## Pull Requests

1. Create branch: `git checkout -b feature/your-feature`
2. Make changes and add tests
3. Run tests: `swift test`
4. Commit: `git commit -m "Add feature: description"`
5. Push: `git push origin feature/your-feature`
6. Create PR on GitHub

### PR Guidelines

- Keep PRs focused and reasonably sized
- Include tests for new functionality
- Update docs if API changes
- Clearly mark breaking changes

## Bug Reports

Include:
- Description of the bug
- Steps to reproduce
- Expected vs actual behavior
- Environment (Swift version, platform, Xcode version)
- Minimal code sample

## Feature Requests

Include:
- Clear description
- Use case explanation
- Proposed API (example code)
- Alternatives considered

## Project Structure

```
Sources/
├── SwiftBorsh/              # Core library
│   ├── SwiftBorsh.swift
│   ├── BorshCodable.swift
│   └── *+BorshCodable.swift # Type extensions
├── SwiftBorshMacros/        # Macro implementations
└── ByteBuffer/              # Byte utilities

Tests/
└── SwiftBorshTests/

docs/
├── API.md
├── CONTRIBUTING.md
└── EXAMPLES.md
```

## Adding Type Support

1. Create `TypeName+BorshCodable.swift`
2. Implement `BorshEncodable` and `BorshDecodable`
3. Add tests
4. Update documentation

Example:

```swift
extension MyType: BorshEncodable {
    public func borshEncode(to buffer: inout BorshByteBuffer) throws {
        // implementation
    }
}

extension MyType: BorshDecodable {
    public init(fromBorshBuffer buffer: inout BorshByteBuffer) throws {
        // implementation
    }
}
```

## Areas Needing Help

- Performance optimization (reduce memory copies)
- Additional type support
- Test coverage
- Documentation improvements

## License

By contributing, you agree your contributions will be licensed under MIT License.
