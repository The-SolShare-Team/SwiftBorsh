import SwiftBorsh

@BorshEncodable
enum MyEnum {
    case A, B
    case C(test: Int32, test2: Int64)
    case D
}

var a: MyEnum

@BorshEncodable
// @BorshDecodable
struct Person {
    var name, name2: String
    var (x, y): (Int, Int)
    var position: (Int, Int)
    var age: Int32
    let score: Float
    let kind: MyEnum
}

// Handle tuple declaration, tuple types
// Handle decoding

print(try! BorshEncoder.encode("Hello World"))
print(
    try! BorshDecoder.decode(
        [11, 0, 0, 0, 72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100], into: String.self))
