public protocol FixedWithFloatingPoint: BinaryFloatingPoint {
    associatedtype BitPattern: FixedWidthInteger
    var bitPattern: BitPattern { get }
    init(bitPattern: BitPattern)
}

@available(macOS 11.0, *)
extension Float16: FixedWithFloatingPoint {}
extension Float32: FixedWithFloatingPoint {}
extension Float64: FixedWithFloatingPoint {}
