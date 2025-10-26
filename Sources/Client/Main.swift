import SwiftBorsh

enum MyEnum {
    case A, B
    case C(test: Int32, test2: Int64, test3: (Int64, Int64))
    case D(Int32, test: Int64, (Int64, Int64), Float32, test3: (String, String, String))
}

extension MyEnum: BorshEncodable {
    public func borshEncode(to buffer: inout BorshByteBuffer) throws(BorshEncodingError) {
        switch self {
        case .A:
            try UInt8(0).borshEncode(to: &buffer)
        case .B:
            try UInt8(1).borshEncode(to: &buffer)
        case .C(let p1, let p2, let (p3, p4)):
            do {
                try UInt8(2).borshEncode(to: &buffer)
                try p1.borshEncode(to: &buffer)
                try p2.borshEncode(to: &buffer)
                try p3.borshEncode(to: &buffer)
                try p4.borshEncode(to: &buffer)
            }
        case .D(let p1, let p2, let (p3, p4), let p5, let (p6, p7, p8)):
            do {
                try UInt8(3).borshEncode(to: &buffer)
                try p1.borshEncode(to: &buffer)
                try p2.borshEncode(to: &buffer)
                try p3.borshEncode(to: &buffer)
                try p4.borshEncode(to: &buffer)
                try p5.borshEncode(to: &buffer)
                try p6.borshEncode(to: &buffer)
                try p7.borshEncode(to: &buffer)
                try p8.borshEncode(to: &buffer)
            }
        }
    }
}

// extension MyEnum: BorshEncodable {
//     public func borshEncode(to buffer: inout BorshByteBuffer) throws(BorshEncodingError) {
//         switch self {
//         case .A:
//             try UInt8(0).borshEncode(to: &buffer)
//         case .B:
//             try UInt8(1).borshEncode(to: &buffer)
//         case .C(let p1, let p2, let (p3, p4)):
//             do {
//                 try UInt8(2).borshEncode(to: &buffer)
//                 try p1.borshEncode(to: &buffer)
//                 try p2.borshEncode(to: &buffer)
//                 try p3.borshEncode(to: &buffer)
//                 try p4.borshEncode(to: &buffer)
//             }
//         case .D(let p1, let p2, let (p3, p4)):
//             do {
//                 try UInt8(3).borshEncode(to: &buffer)
//                 try p1.borshEncode(to: &buffer)
//                 try p2.borshEncode(to: &buffer)
//                 try p3.borshEncode(to: &buffer)
//                 try p4.borshEncode(to: &buffer)
//             }
//         }
//     }
// }

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

// @BorshEncodable
// @BorshDecodable
struct Person {
    var name, name2: String
    // var (x, y): (Int, Int)
    // var position: (Int, Int)
    var age: Int32
    let score: Float
    // let kind: MyEnum
}

// Handle tuple declaration, tuple types
// Handle decoding

print(try! BorshEncoder.encode("Hello World"))
print(
    try! BorshDecoder.decode(
        [11, 0, 0, 0, 72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100], into: String.self))
