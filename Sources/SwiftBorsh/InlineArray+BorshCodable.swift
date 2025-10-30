@available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
extension InlineArray: BorshEncodable where Element: BorshEncodable {
    public func borshEncode(to buffer: inout BorshByteBuffer) throws(BorshEncodingError) {
        for i in self.indices {
            try self[i].borshEncode(to: &buffer)
        }
    }
}

@available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
extension InlineArray: BorshDecodable where Element: BorshDecodable {
    public init(fromBorshBuffer buffer: inout BorshByteBuffer) throws(BorshDecodingError) {
        let closure: (Int) throws(BorshDecodingError) -> Element = { _ in
            try Element(fromBorshBuffer: &buffer)
        }
        try self.init(closure)
    }
}
