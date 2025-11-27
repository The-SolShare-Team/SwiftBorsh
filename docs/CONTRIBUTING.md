# Contributing to SwiftBorsh

Thank you for your interest in contributing to SwiftBorsh! This document provides guidelines and instructions for contributing to the project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [How to Contribute](#how-to-contribute)
- [Code Style Guidelines](#code-style-guidelines)
- [Testing Guidelines](#testing-guidelines)
- [Submitting Changes](#submitting-changes)
- [Reporting Bugs](#reporting-bugs)
- [Requesting Features](#requesting-features)
- [Project Structure](#project-structure)

## Code of Conduct

We are committed to providing a welcoming and inclusive environment for all contributors. Please be respectful and constructive in all interactions.

## Getting Started

### Prerequisites

- Swift 6.2 or later
- Xcode 16.0 or later (for macOS development)
- Git
- Familiarity with Swift Package Manager
- Understanding of the [Borsh specification](https://borsh.io/)

### Fork and Clone

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/YOUR-USERNAME/SwiftBorsh.git
   cd SwiftBorsh
   ```
3. Add the upstream repository:
   ```bash
   git remote add upstream https://github.com/The-SolShare-Team/SwiftBorsh.git
   ```

## Development Setup

### Building the Project

```bash
swift build
```

### Running Tests

```bash
swift test
```

### Running Specific Tests

```bash
swift test --filter SwiftBorshTests.testName
```

### Generating Documentation

```bash
swift package generate-documentation
```

## How to Contribute

### Types of Contributions

We welcome various types of contributions:

1. **Bug Fixes**: Fix issues in existing code
2. **New Features**: Add support for new types or functionality
3. **Performance Improvements**: Optimize encoding/decoding performance
4. **Documentation**: Improve or add documentation
5. **Tests**: Add or improve test coverage
6. **Examples**: Provide usage examples

### Areas Needing Help

- **Performance Optimization**: Reducing memory copies during serialization
- **Type Support**: Expanding support for more Swift types
- **Documentation**: Adding more examples and use cases
- **Testing**: Improving test coverage
- **Macro Improvements**: Enhancing the macro expansion for edge cases

## Code Style Guidelines

### Swift Style

Follow these style guidelines for consistency:

1. **Naming Conventions**:
   - Use camelCase for variables and functions
   - Use PascalCase for types (structs, enums, classes, protocols)
   - Use meaningful, descriptive names

2. **Formatting**:
   - Indent with 4 spaces (no tabs)
   - Maximum line length: 100 characters (flexible for readability)
   - Use trailing commas in multi-line array/dictionary literals

3. **Code Organization**:
   - Group related functionality together
   - Use `// MARK: -` comments to organize code sections
   - Place protocol conformance in extensions when possible

4. **Documentation**:
   - Add doc comments for public APIs
   - Use `///` for documentation comments
   - Include examples in documentation where helpful

### Example

```swift
/// Encodes a value to Borsh binary format.
///
/// - Parameter value: The value to encode
/// - Returns: An array of bytes representing the encoded value
/// - Throws: `BorshEncodingError` if encoding fails
///
/// Example:
/// ```swift
/// let bytes = try BorshEncoder.encode(myValue)
/// ```
public static func encode(_ value: any BorshEncodable) throws(BorshEncodingError) -> [UInt8] {
    var buffer = ByteBuffer()
    try value.borshEncode(to: &buffer)
    return buffer.readBytes(length: buffer.readableBytes) ?? []
}
```

## Testing Guidelines

### Writing Tests

1. **Test Coverage**: All new code should have corresponding tests
2. **Test Naming**: Use descriptive test names that explain what is being tested
3. **Test Organization**: Group related tests together
4. **Edge Cases**: Test boundary conditions and error cases

### Test Structure

```swift
@Test func testEncodingStructWithOptionalFields() {
    // Given
    @BorshCodable
    struct TestStruct {
        let required: String
        let optional: String?
    }

    let value = TestStruct(required: "test", optional: nil)

    // When
    let encoded = try BorshEncoder.encode(value)

    // Then
    #expect(encoded == [4, 0, 0, 0, 116, 101, 115, 116, 0])
}
```

### Testing Checklist

- [ ] Round-trip testing (encode then decode produces same value)
- [ ] Null/empty value handling
- [ ] Large values (collections, strings)
- [ ] Error conditions
- [ ] Edge cases for numeric types (min, max, zero)
- [ ] Platform-specific features (when applicable)

## Submitting Changes

### Pull Request Process

1. **Create a Branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make Changes**:
   - Write your code
   - Add tests
   - Update documentation

3. **Test Your Changes**:
   ```bash
   swift test
   swift build
   ```

4. **Commit Your Changes**:
   ```bash
   git add .
   git commit -m "Add feature: description of changes"
   ```

   Follow commit message conventions:
   - Use present tense ("Add feature" not "Added feature")
   - Use imperative mood ("Move cursor to..." not "Moves cursor to...")
   - Start with a capital letter
   - Keep first line under 72 characters
   - Add detailed description if needed

5. **Push to Your Fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create Pull Request**:
   - Go to GitHub and create a pull request
   - Fill out the PR template
   - Link any related issues
   - Request review from maintainers

### Pull Request Guidelines

- **Title**: Clear and descriptive
- **Description**: Explain what changes were made and why
- **Tests**: Include tests for new functionality
- **Documentation**: Update docs if API changes
- **Breaking Changes**: Clearly mark breaking changes
- **Small PRs**: Keep PRs focused and reasonably sized

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
Describe how you tested your changes

## Checklist
- [ ] Tests pass locally
- [ ] New tests added for new functionality
- [ ] Documentation updated
- [ ] Code follows style guidelines
```

## Reporting Bugs

### Before Reporting

1. Check if the issue already exists
2. Verify you're using the latest version
3. Ensure it's not a usage error

### Bug Report Template

```markdown
**Description**
Clear description of the bug

**To Reproduce**
Steps to reproduce:
1. Step one
2. Step two
3. See error

**Expected Behavior**
What you expected to happen

**Actual Behavior**
What actually happened

**Environment**
- SwiftBorsh version: [e.g., 1.0.0]
- Swift version: [e.g., 6.2]
- Platform: [e.g., macOS 14.0, iOS 17.0]
- Xcode version: [e.g., 16.0]

**Code Sample**
```swift
// Minimal code to reproduce
```

**Additional Context**
Any other relevant information
```

## Requesting Features

### Feature Request Template

```markdown
**Feature Description**
Clear description of the feature

**Use Case**
Explain why this feature would be useful

**Proposed API**
Example of how the API might look:
```swift
// Example usage
```

**Alternatives Considered**
Other approaches you've considered

**Additional Context**
Any other relevant information
```

## Project Structure

```
SwiftBorsh/
├── Sources/
│   ├── SwiftBorsh/              # Main library code
│   │   ├── SwiftBorsh.swift     # Core types and entry points
│   │   ├── BorshCodable.swift   # Protocol definitions
│   │   ├── Bool+BorshCodable.swift
│   │   ├── String+BorshCodable.swift
│   │   ├── Array+BorshCodable.swift
│   │   ├── Dictionary+BorshCodable.swift
│   │   ├── Set+BorshCodable.swift
│   │   ├── Option+BorshCodable.swift
│   │   ├── Result+BorshCodable.swift
│   │   ├── FixedWidthInteger+BorshCodable.swift
│   │   ├── FixedWidthFloatingPoint+BorshCodable.swift
│   │   └── InlineArray+BorshCodable.swift
│   ├── SwiftBorshMacros/         # Macro implementations
│   │   ├── SwiftBorshPlugin.swift
│   │   ├── BorshEncodableMacro.swift
│   │   ├── BorshDecodableMacro.swift
│   │   └── BorshCodableMacro.swift
│   └── ByteBuffer/               # Byte buffer utilities
├── Tests/
│   └── SwiftBorshTests/
│       └── SwiftBorshTests.swift
├── docs/                         # Documentation
│   ├── API.md
│   ├── CONTRIBUTING.md
│   └── EXAMPLES.md
├── Package.swift                 # Swift Package Manager manifest
└── README.md
```

### Key Components

1. **Core Protocols** (`BorshCodable.swift`):
   - `BorshEncodable`, `BorshDecodable`, `BorshCodable`
   - Error types

2. **Encoder/Decoder** (`SwiftBorsh.swift`):
   - `BorshEncoder.encode(_:)`
   - `BorshDecoder.decode(_:into:)`

3. **Type Extensions**:
   - Each file adds `BorshCodable` conformance for a specific type
   - Follow existing patterns when adding new type support

4. **Macros**:
   - Use Swift Syntax for AST manipulation
   - Generate conformance code at compile time

## Development Workflow

### Adding Support for a New Type

1. Create a new file: `TypeName+BorshCodable.swift`
2. Implement `BorshEncodable` conformance
3. Implement `BorshDecodable` conformance
4. Add tests in `SwiftBorshTests.swift`
5. Update documentation

Example:

```swift
// Sources/SwiftBorsh/MyType+BorshCodable.swift

extension MyType: BorshEncodable {
    public func borshEncode(to buffer: inout BorshByteBuffer) throws(BorshEncodingError) {
        // Implementation
    }
}

extension MyType: BorshDecodable {
    public init(fromBorshBuffer buffer: inout BorshByteBuffer) throws(BorshDecodingError) {
        // Implementation
    }
}
```

### Improving Macro Support

1. Edit the relevant macro file in `SwiftBorshMacros/`
2. Add test cases
3. Verify macro expansion with:
   ```bash
   swift build && swift test
   ```

### Performance Optimization

1. Identify bottleneck (use Instruments on macOS)
2. Create benchmark test
3. Implement optimization
4. Verify performance improvement
5. Ensure tests still pass

## Communication

### Where to Ask Questions

- **GitHub Issues**: For bugs and feature requests
- **GitHub Discussions**: For general questions and discussions
- **Pull Requests**: For code review and implementation discussions

### Getting Help

If you're stuck:

1. Check the documentation
2. Look at existing code for examples
3. Search closed issues
4. Ask in GitHub Discussions

## Recognition

Contributors will be recognized in:

- The project's README
- Release notes (for significant contributions)
- GitHub's contributor graph

## License

By contributing to SwiftBorsh, you agree that your contributions will be licensed under the same license as the project (MIT License).

## Thank You!

Thank you for contributing to SwiftBorsh! Every contribution, whether it's code, documentation, bug reports, or feature suggestions, helps make this project better for everyone.
