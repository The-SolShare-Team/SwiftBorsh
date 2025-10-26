import Testing

@testable import SwiftBorsh

@BorshEncodable
struct Person {
    let name: String
    let age: UInt64
    let score: Float
}

@Test func example() async throws {
    #expect(
        try! BorshEncoder.encode(Person(name: "Samuel", age: 19, score: 0.5))
            == [6, 0, 0, 0, 83, 97, 109, 117, 101, 108, 19, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 63])
}
