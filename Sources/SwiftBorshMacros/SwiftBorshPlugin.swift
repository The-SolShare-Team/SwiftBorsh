import SwiftCompilerPlugin
import SwiftSyntaxMacros

// Entry point for the Swift Borsh plugin.
// Registers macros for `BorshEncodable` and `BorshDecodable` conformance.
@main
struct SwiftBorshPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        BorshEncodableMacro.self,
        BorshDecodableMacro.self,
    ]
}
