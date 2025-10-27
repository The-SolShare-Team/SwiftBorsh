import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct BorshCodableMacro: ExtensionMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo protocols: [SwiftSyntax.TypeSyntax],
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        let encoding = try BorshEncodableMacro.expansion(
            of: node, attachedTo: declaration, providingExtensionsOf: type, conformingTo: protocols,
            in: context)
        let decoding = try BorshDecodableMacro.expansion(
            of: node, attachedTo: declaration, providingExtensionsOf: type, conformingTo: protocols,
            in: context)
        return encoding + decoding
    }
}
