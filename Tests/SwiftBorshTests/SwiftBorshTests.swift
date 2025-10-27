import Testing

@testable import SwiftBorsh

@BorshEncodable
struct Person {
    let name: String
    let age: UInt64
    let score: Float
}

@BorshEncodable
enum MyEnum {
    case A, B
    case C(test: Int32, test2: Int64, test3: (Int64, Int64))
    case D(Int32, test: Int64, (Int64, Int64), Float32, test3: (String, String, String))
}

@BorshEncodable
struct WeirdPerson {
    var name, name2: String
    var (x, y): (Int64, (Int64, String))
    var position, position2: (Int32, Int32), position3: String
    var age: Int32
    let score: Float
    let kind: MyEnum
}

@Test func encodePerson() {
    #expect(
        try! BorshEncoder.encode(Person(name: "Samuel", age: 19, score: 0.5))
            == [6, 0, 0, 0, 83, 97, 109, 117, 101, 108, 19, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 63])
}

@Test func encodeWeirdPerson() {
    #expect(
        try! BorshEncoder.encode(
            WeirdPerson(
                name: "Samuel", name2: "Martineau", x: 1, y: (2, "Boucher"), position: (3, 4),
                position2: (5, 6), position3: "Dan", age: 42, score: 0.5,
                kind: .D(13, test: 14, (15, 16), 0.7, test3: ("A", "B", "C")))) == [
                6, 0, 0, 0, 83, 97, 109, 117, 101, 108, 9, 0, 0, 0, 77, 97, 114, 116, 105, 110, 101,
                97, 117, 1, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 66, 111, 117,
                99, 104, 101, 114, 3, 0, 0, 0, 4, 0, 0, 0, 5, 0, 0, 0, 6, 0, 0, 0, 3, 0, 0, 0, 68,
                97, 110, 42, 0, 0, 0, 0, 0, 0, 63, 3, 13, 0, 0, 0, 14, 0, 0, 0, 0, 0, 0, 0, 15, 0,
                0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 0, 0, 0, 0, 51, 51, 51, 63, 1, 0, 0, 0, 65, 1, 0, 0,
                0, 66, 1, 0, 0, 0, 67,
            ])
}
