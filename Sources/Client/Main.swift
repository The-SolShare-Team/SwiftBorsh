import SwiftBorsh

@BorshCodable
enum MyEnum {
    case A, B
    case C(test: Int32, test2: Int64, test3: (Int64, Int64))
    case D(Int32, test: Int64, (Int64, Int64), Float32, test3: (String, String, String))
}

@BorshCodable
struct Person {
    var name, name2: String
    var (x, y): (Int64, (Int64, String))
    var position, position2: (Int32, Int32), position3: String
    var age: Int32
    let score: Float
    let kind: MyEnum
}
