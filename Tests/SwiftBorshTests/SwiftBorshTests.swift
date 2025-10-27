import Testing

@testable import SwiftBorsh

@BorshCodable
struct Person: Equatable {
    let name: String
    let age: UInt64
    let score: Float
}

@BorshCodable
enum MyEnum: Equatable {
    case A, B
    case C(test: Int32, test2: Int64, test3: (Int64, Int64))
    case D(Int32, test: Int64, (Int64, Int64), Float32, test3: (String, String, String))

    static func == (lhs: MyEnum, rhs: MyEnum) -> Bool {
        switch (lhs, rhs) {
        case (.A, .A), (.B, .B):
            return true
        case (.C(let test1, let test2_1, let test3_1), .C(let test2, let test2_2, let test3_2)):
            return test1 == test2 && test2_1 == test2_2 && test3_1 == test3_2
        case (
            .D(let v1, let test1, let tuple1, let float1, let test3_1),
            .D(let v2, let test2, let tuple2, let float2, let test3_2)
        ):
            return v1 == v2 && test1 == test2 && tuple1 == tuple2 && float1 == float2
                && test3_1 == test3_2
        default:
            return false
        }
    }
}

@BorshCodable
struct WeirdPerson: Equatable {
    var name, name2: String
    var (x, y): (Int64, (Int64, String))
    var position, position2: (Int32, Int32), position3: String
    var age: Int32
    let score: Float
    let kind: MyEnum

    static func == (lhs: WeirdPerson, rhs: WeirdPerson) -> Bool {
        return lhs.name == rhs.name && lhs.name2 == rhs.name2 && lhs.x == rhs.x && lhs.y == rhs.y
            && lhs.position == rhs.position && lhs.position2 == rhs.position2
            && lhs.position3 == rhs.position3 && lhs.age == rhs.age && lhs.score == rhs.score
            && lhs.kind == rhs.kind
    }
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

@Test func decodePerson() {
    #expect(
        try! BorshDecoder.decode(
            [6, 0, 0, 0, 83, 97, 109, 117, 101, 108, 19, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 63],
            into: Person.self) == Person(name: "Samuel", age: 19, score: 0.5)
    )
}

@Test func decodeWeirdPerson() {
    #expect(
        try! BorshDecoder.decode(
            [
                6, 0, 0, 0, 83, 97, 109, 117, 101, 108, 9, 0, 0, 0, 77, 97, 114, 116, 105, 110, 101,
                97, 117, 1, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 66, 111, 117,
                99, 104, 101, 114, 3, 0, 0, 0, 4, 0, 0, 0, 5, 0, 0, 0, 6, 0, 0, 0, 3, 0, 0, 0, 68,
                97, 110, 42, 0, 0, 0, 0, 0, 0, 63, 3, 13, 0, 0, 0, 14, 0, 0, 0, 0, 0, 0, 0, 15, 0,
                0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 0, 0, 0, 0, 51, 51, 51, 63, 1, 0, 0, 0, 65, 1, 0, 0,
                0, 66, 1, 0, 0, 0, 67,
            ], into: WeirdPerson.self)
            == WeirdPerson(
                name: "Samuel", name2: "Martineau", x: 1, y: (2, "Boucher"), position: (3, 4),
                position2: (5, 6), position3: "Dan", age: 42, score: 0.5,
                kind: .D(13, test: 14, (15, 16), 0.7, test3: ("A", "B", "C"))))
}
