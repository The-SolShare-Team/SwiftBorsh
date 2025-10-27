import SwiftBorsh

@BorshEncodable
enum MyEnum {
    case A, B
    case C(test: Int32, test2: Int64, test3: (Int64, Int64))
    case D(Int32, test: Int64, (Int64, Int64), Float32, test3: (String, String, String))
}

// extension MyEnum: BorshDecodable {
//     init(fromBorshBuffer buffer: inout SwiftBorsh.BorshByteBuffer) throws(SwiftBorsh
//         .BorshDecodingError)
//     {
//         guard let variant = buffer.readInteger(endianness: .little, as: UInt8.self) else {
//             throw BorshDecodingError.endOfBuffer
//         }
//         switch variant {
//         case 0: self = MyEnum.A
//         case 1: self = MyEnum.B
//         case 2:
//             self = MyEnum.C(
//                 test: try Int32(fromBorshBuffer: &buffer),
//                 test2: try Int64(fromBorshBuffer: &buffer),
//                 test3: (try Int64(fromBorshBuffer: &buffer), try Int64(fromBorshBuffer: &buffer)))
//         case 3:
//             self = MyEnum.D(
//                 try Int32(fromBorshBuffer: &buffer), test: try Int64(fromBorshBuffer: &buffer),
//                 (try Int64(fromBorshBuffer: &buffer), try Int64(fromBorshBuffer: &buffer)))
//         default: throw BorshDecodingError.invalidValue
//         }
//     }
// }

// var a: MyEnum

@BorshEncodable
struct Person {
    var name, name2: String
    var (x, y): (Int64, (Int64, String))
    var position, position2: (Int32, Int32), position3: String
    var age: Int32
    let score: Float
    let kind: MyEnum
}

// Handle tuple declaration, tuple types
// Handle decoding
// Diagnostics field conformance to encodable

print(try! BorshEncoder.encode("Hello World"))
print(
    try! BorshDecoder.decode(
        [11, 0, 0, 0, 72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100], into: String.self))
