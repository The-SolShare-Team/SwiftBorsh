import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct BorshDecodableMacro: ExtensionMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo protocols: [SwiftSyntax.TypeSyntax],
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        if protocols.isEmpty {
            context.diagnose(
                Diagnostic(
                    node: node,
                    message: MacroExpansionWarningMessage(
                        "\(type.trimmed) already conforms to BorshDecodable")))
            return []
        }

        switch declaration {
        case let structDecl as StructDeclSyntax:
            do {
                var body: [String] = []

                for member in structDecl.memberBlock.members {
                    guard let varDecl = member.decl.as(VariableDeclSyntax.self) else { continue }

                    // for binding in varDecl.bindings {
                    //     guard let identifier = binding.pattern.as(IdentifierPatternSyntax.self)
                    //     else {
                    //         continue
                    //     }

                    //     context.diagnose(
                    //         Diagnostic(
                    //             node: node,
                    //             message: MacroExpansionWarningMessage(
                    //                 "Found \(binding.typeAnnotation)")))

                    //     body.append("\(identifier) = 1")
                    // }

                    for binding in varDecl.bindings {
                        // Get the name of the variable
                        let names: [String] = {
                            if let identPattern = binding.pattern.as(IdentifierPatternSyntax.self) {
                                return [identPattern.identifier.text]
                            } else if let tuple = binding.pattern.as(TuplePatternSyntax.self) {
                                return tuple.elements.compactMap {
                                    $0.pattern.as(IdentifierPatternSyntax.self)?.identifier.text
                                }
                            }
                            return []
                        }()

                        // Get type annotation (optional)
                        let type = binding.typeAnnotation?.type.description ?? "Unknown"

                        for name in names {
                            context.diagnose(
                                Diagnostic(
                                    node: node,
                                    message: MacroExpansionWarningMessage(
                                        "Property: \(name), Type: \(type)")))
                        }
                    }
                }

                return [
                    try ExtensionDeclSyntax(
                        """
                        extension \(type.trimmed): BorshDecodable {
                            public init(fromBorshBuffer buffer: inout BorshByteBuffer) throws(BorshDecodingError) {
                                \(raw: body.joined(separator: "\n"))
                            }
                        }
                        """)
                ]
            }
        default:
            throw MacroExpansionErrorMessage(
                "Macro BorshEncodable can only be applied to a struct or enum")
        }
    }
}
