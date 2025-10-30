import Testing

@testable import SwiftBorsh

@BorshCodable
struct Person: Equatable {
    let name: String
    let age: UInt64
    let score: Float
}

@BorshCodable
struct PersonTwo: Equatable {
    let id: String
    let assignee: String
    let projectId: String
    let name: String
    let description: String
    let status: String
}

@BorshCodable
struct TypedStruct: Equatable {
    let name: String
    let age: UInt8
    let flag: Bool
    let scores: [Float]
    let optionalNote: String?
    let tags: [String]
    let attributes: [String: Int32]
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

@BorshCodable
enum TestError: Error, Equatable {
    case code(Int32)
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

@Test func decodePersonTwo() {
    let encodedPersonTwo =
        "9bZQRpENKBeHiJ7Hu6x3K7kZcEAXNCGhbb7W5siuzMyFZ5FeEmV2th7tLrrKM7Cb1FDHPUegqZu6ZTPf7A61tLKJCQU"
    #expect(
        try! BorshDecoder.base58Decode(encodedPersonTwo, into: PersonTwo.self)
            == PersonTwo(
                id: "APPLE",
                assignee: "Sai",
                projectId: "ABX",
                name: "Hello",
                description: "Sample task Example",
                status: "NOT DONE"
            )
    )
}

@Test func encodePersonTwo() {
    let personTwo = PersonTwo(
        id: "APPLE",
        assignee: "Sai",
        projectId: "ABX",
        name: "Hello",
        description: "Sample task Example",
        status: "NOT DONE"
    )
    #expect(
        try! BorshEncoder.base58Encode(personTwo)
            == "9bZQRpENKBeHiJ7Hu6x3K7kZcEAXNCGhbb7W5siuzMyFZ5FeEmV2th7tLrrKM7Cb1FDHPUegqZu6ZTPf7A61tLKJCQU"
    )
}

@Test func encodeTypedStructToBytes() {
    let value = TypedStruct(
        name: "Alice",
        age: 30,
        flag: true,
        scores: [1.0, 2.0],
        optionalNote: "Hello World",
        tags: ["swift", "borsh"],
        attributes: ["speed": 100, "skill": 42]
    )

    let expectedEncoded: [UInt8] = [
        5, 0, 0, 0, 65, 108, 105, 99, 101,
        30, 1, 2, 0, 0, 0, 0, 0, 128, 63, 0, 0, 0, 64, 1, 11, 0, 0, 0, 72,
        101, 108, 108, 111, 32, 87, 111, 114, 108, 100, 2, 0, 0, 0, 5, 0,
        0, 0, 115, 119, 105, 102, 116, 5, 0, 0, 0, 98, 111, 114, 115, 104, 2,
        0, 0, 0, 5, 0, 0, 0, 115, 107, 105, 108, 108, 42, 0, 0, 0, 5, 0, 0, 0,
        115, 112, 101, 101, 100, 100, 0, 0, 0,
    ]
    let encoded = try! BorshEncoder.encode(value)
    #expect(encoded == expectedEncoded)
}

@Test func decodeTypedStructFromBytes() {

    let expected = TypedStruct(
        name: "Alice",
        age: 30,
        flag: true,
        scores: [1.0, 2.0],
        optionalNote: "Hello World",
        tags: ["swift", "borsh"],
        attributes: ["speed": 100, "skill": 42]
    )

    let decoded = try! BorshDecoder.decode(
        [
            5, 0, 0, 0, 65, 108, 105, 99, 101,
            30, 1, 2, 0, 0, 0, 0, 0, 128, 63, 0, 0, 0, 64, 1, 11, 0, 0, 0, 72,
            101, 108, 108, 111, 32, 87, 111, 114, 108, 100, 2, 0, 0, 0, 5, 0,
            0, 0, 115, 119, 105, 102, 116, 5, 0, 0, 0, 98, 111, 114, 115, 104, 2,
            0, 0, 0, 5, 0, 0, 0, 115, 107, 105, 108, 108, 42, 0, 0, 0, 5, 0, 0, 0,
            115, 112, 101, 101, 100, 100, 0, 0, 0,
        ], into: TypedStruct.self)

    #expect(decoded == expected)
}

@Test func testTypedStructEncodeAndDecode() {
    let original = TypedStruct(
        name: "Alice",
        age: 30,
        flag: true,
        scores: [1.0, 2.0],
        optionalNote: "Hello World",
        tags: ["swift", "borsh"],
        attributes: ["speed": 100, "skill": 42],
    )

    var buffer = BorshByteBuffer()
    try! original.borshEncode(to: &buffer)
    let decoded = try! TypedStruct(fromBorshBuffer: &buffer)
    #expect(decoded == original)
}

@Test func testTypedStructOptionalNil() {
    let original = TypedStruct(
        name: "Bob",
        age: 25,
        flag: false,
        scores: [],
        optionalNote: nil,
        tags: [],
        attributes: [:],
    )

    var buffer = BorshByteBuffer()
    try! original.borshEncode(to: &buffer)
    let decoded = try! TypedStruct(fromBorshBuffer: &buffer)
    #expect(decoded == original)
}

@Test func testTypedStructEmptyCollections() {
    let original = TypedStruct(
        name: "Empty",
        age: 0,
        flag: false,
        scores: [],
        optionalNote: nil,
        tags: [],
        attributes: [:],
    )

    var buffer = BorshByteBuffer()
    try! original.borshEncode(to: &buffer)
    let decoded = try! TypedStruct(fromBorshBuffer: &buffer)
    #expect(decoded == original)
}

@available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
extension InlineArray: @retroactive Sequence {
    public func makeIterator() -> AnyIterator<Element> {
        var index = 0
        return AnyIterator {
            guard index < Int(count) else { return nil }
            defer { index += 1 }
            return self[index]
        }
    }
}

@available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
extension InlineArray: @retroactive Equatable where Element: Equatable {
    public static func == (lhs: InlineArray<count, Element>, rhs: InlineArray<count, Element>)
        -> Bool
    {
        return zip(lhs, rhs).allSatisfy { $0 == $1 }
    }
}

@available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
@Test func encodeInlineArray() {
    let arr: InlineArray<3, String> = ["Alpha", "Beta", "Gamma"]
    #expect(
        try! BorshEncoder.encode(arr) == [
            5, 0, 0, 0, 65, 108, 112, 104, 97, 4, 0, 0, 0, 66, 101, 116, 97, 5, 0, 0, 0, 71, 97,
            109, 109, 97,
        ])
}

@available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
@Test func decodeInlineArray() {
    let arr: InlineArray<3, String> = ["Alpha", "Beta", "Gamma"]
    #expect(
        try! BorshDecoder.decode(
            [
                5, 0, 0, 0, 65, 108, 112, 104, 97, 4, 0, 0, 0, 66, 101, 116, 97, 5, 0, 0, 0, 71, 97,
                109, 109, 97,
            ], into: InlineArray<3, String>.self) == arr)
}

@Test func testResultEncodeDecodeSuccess() {
    let original: Result<String, TestError> = .success("Operation completed")
    let encoded = try! BorshEncoder.encode(original)
    let decoded = try! BorshDecoder.decode(encoded, into: Result<String, TestError>.self)
    #expect(decoded == original)
}

@Test func testResultEncodeDecodeFailure() {
    let original: Result<String, TestError> = .failure(.code(404))
    let encoded = try! BorshEncoder.encode(original)
    let decoded = try! BorshDecoder.decode(encoded, into: Result<String, TestError>.self)
    #expect(decoded == original)
}

@Test func testSetEncodeDecodeNonEmpty() {
    let original: Set<String> = ["apple", "banana", "cherry"]
    let encoded = try! BorshEncoder.encode(original)
    let decoded = try! BorshDecoder.decode(encoded, into: Set<String>.self)
    #expect(decoded == original)
}

@Test func testSetEncodeDecodeEmpty() {
    let original: Set<Int16> = []
    let encoded = try! BorshEncoder.encode(original)
    let decoded = try! BorshDecoder.decode(encoded, into: Set<Int16>.self)
    #expect(decoded == original)
}
