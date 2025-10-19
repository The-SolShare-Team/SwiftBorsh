public protocol FixedWithFloatingPoint: BinaryFloatingPoint {
    associatedtype BitPattern: FixedWidthInteger
    var bitPattern: BitPattern { get }
    init(bitPattern: BitPattern)
}

#if arch(arm64)
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    extension Float16: FixedWithFloatingPoint {}
#endif
extension Float32: FixedWithFloatingPoint {}
extension Float64: FixedWithFloatingPoint {}
