//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftNIO open source project
//
// Copyright (c) 2020 Apple Inc. and the SwiftNIO project authors
// Licensed under Apache License v2.0
//
// See https://raw.githubusercontent.com/apple/swift-nio/86c5ead5ddaab0462b9831cca4c292ab42992d63/LICENSE.txt for license information
// See https://raw.githubusercontent.com/apple/swift-nio/86c5ead5ddaab0462b9831cca4c292ab42992d63/CONTRIBUTORS.txt for the list of SwiftNIO project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

#if canImport(Dispatch)
    import Dispatch
#endif

extension String {

    /// Creates a `String` from a given `ByteBuffer`. The entire readable portion of the buffer will be read.
    /// - Parameter buffer: The buffer to read.
    @inlinable
    init(buffer: ByteBuffer) {
        var buffer = buffer
        self = buffer.readString(length: buffer.readableBytes)!
    }

    /// Creates a `String` from a given `Int` with a given base (`radix`), padded with zeroes to the provided `padding` size.
    ///
    /// - Parameters:
    ///   - radix: radix base to use for conversion.
    ///   - padding: the desired length of the resulting string.
    @inlinable
    init<Value>(_ value: Value, radix: Int, padding: Int) where Value: BinaryInteger {
        let formatted = String(value, radix: radix)
        self = String(repeating: "0", count: padding - formatted.count) + formatted
    }
}
