import Testing

@testable import Base58

@Test func encodeHelloWorld() {
    let input: [UInt8] = Array("Hello World!".utf8)
    let output = Base58.encode(input)
    #expect(output == "2NEpo7TZRRrLZSi2U")
}

@Test func decodeHelloWorld() {
    let input = "2NEpo7TZRRrLZSi2U"
    let output = try! Base58.decode(input)
    #expect(output == Array("Hello World!".utf8))
}

@Test func encodeQuickBrownFox() {
    let input: [UInt8] = Array("The quick brown fox jumps over the lazy dog.".utf8)
    let output = Base58.encode(input)
    #expect(output == "USm3fpXnKG5EUBx2ndxBDMPVciP5hGey2Jh4NDv6gmeo1LkMeiKrLJUUBk6Z")
}

@Test func decodeQuickBrownFox() {
    let input = "USm3fpXnKG5EUBx2ndxBDMPVciP5hGey2Jh4NDv6gmeo1LkMeiKrLJUUBk6Z"
    let output = try! Base58.decode(input)
    #expect(output == Array("The quick brown fox jumps over the lazy dog.".utf8))
}
