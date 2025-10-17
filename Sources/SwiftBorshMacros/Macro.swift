import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct BorshEncodableMacro: ExtensionMacro {
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
                        "\(type.trimmed) already conforms to BorshEncodable")))
            return []
        }

        switch declaration {
        case let structDecl as StructDeclSyntax:
            do {
                var body: [String] = []

                for member in structDecl.memberBlock.members {
                    guard let varDecl = member.decl.as(VariableDeclSyntax.self) else { continue }

                    for binding in varDecl.bindings {
                        guard let identifier = binding.pattern.as(IdentifierPatternSyntax.self)
                        else {
                            continue
                        }

                        body.append("try \(identifier.identifier).borshEncode(to: &buffer)")
                    }
                }

                return [
                    try ExtensionDeclSyntax(
                        """
                        extension \(type.trimmed): BorshEncodable {
                            public func borshEncode(to buffer: inout BorshByteBuffer) throws(BorshEncodingError) {
                                \(raw: body.joined(separator: "\n"))
                            }
                        }
                        """)
                ]
            }
        case let enumDecl as EnumDeclSyntax:
            do {
                var body: [String] = []
                var i = 0

                for member in enumDecl.memberBlock.members {
                    guard let caseDecl = member.decl.as(EnumCaseDeclSyntax.self) else { continue }

                    for element in caseDecl.elements {
                        if let parameterClause = element.parameterClause {
                            let parameters = (1...parameterClause.parameters.count).map { "p\($0)" }
                            body.append(
                                """
                                case .\(element.name)(\(parameters.map { "let \($0)" }.joined(separator: ", "))): do {
                                    try UInt8(\(i)).borshEncode(to: &buffer)
                                    \(parameters.map { "try \($0).borshEncode(to: &buffer)" }.joined(separator: "\n"))
                                }
                                """)
                        } else {
                            body.append(
                                "case .\(element.name): try UInt8(\(i)).borshEncode(to: &buffer)")
                        }

                        i += 1
                    }
                }

                return [
                    try ExtensionDeclSyntax(
                        """
                        extension \(type.trimmed): BorshEncodable {
                            public func borshEncode(to buffer: inout BorshByteBuffer) throws(BorshEncodingError) {
                                switch self {
                                \(raw: body.joined(separator: "\n"))
                                }
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

@main
struct SwiftBorshPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        BorshEncodableMacro.self,
        BorshDecodableMacro.self,
    ]
}
