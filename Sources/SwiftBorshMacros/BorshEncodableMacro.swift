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
        // Check if the type already conforms to the `BorshEncodable` protocol.
        // If the type already conforms to the protocol, a warning is issued to notify the developer
        // that the macro is redundant. This prevents unnecessary code generation.
        if protocols.isEmpty {
            context.diagnose(
                Diagnostic(
                    node: node,
                    message: MacroExpansionWarningMessage(
                        "\(type.trimmed) already conforms to BorshEncodable")))
            return []
        }

        switch declaration {
        // Handle structs
        case let structDecl as StructDeclSyntax:
            do {
                var body: [String] = []

                // Loop through each member (var)
                for member in structDecl.memberBlock.members {
                    guard let varDecl = member.decl.as(VariableDeclSyntax.self) else { continue }

                    // Loop through each binding in the member in reverse to get the type first (e.g. var a, b, c: Int)
                    var currentTypeAnnotation: TypeAnnotationSyntax?
                    var memberSubBody: [String] = []  // Needed for correct ordering of bindings
                    for binding in varDecl.bindings.reversed() {
                        currentTypeAnnotation = binding.typeAnnotation ?? currentTypeAnnotation  // Keep the last type annotation if there is none for the current binding

                        // Build identifierTypePairs array.
                        // For regular identifiers, the array will only contain 1 element.
                        // For tuple identifiers, it may contain more.
                        var identifierTypePairs = [
                            (IdentifierPatternSyntax, TypeSyntax)
                        ]()
                        if let identifier = binding.pattern.as(IdentifierPatternSyntax.self) {
                            // For regular identifier
                            identifierTypePairs.append((identifier, currentTypeAnnotation!.type))
                        } else if let tupleIdentifier = binding.pattern.as(TuplePatternSyntax.self),
                            let tupleType = currentTypeAnnotation!.type.as(TupleTypeSyntax.self)
                        {
                            // For tuple identifier
                            for (identifier, annotation) in zip(
                                tupleIdentifier.elements, tupleType.elements
                            ).reversed() {
                                identifierTypePairs.append(
                                    (
                                        identifier.pattern.as(IdentifierPatternSyntax.self)!,
                                        annotation.type
                                    ))
                            }
                        }

                        // Generate code
                        for (identifier, annotation) in identifierTypePairs {
                            if let tupleType = annotation.as(TupleTypeSyntax.self) {
                                // For tuple type
                                for i in (0..<tupleType.elements.count).reversed() {
                                    memberSubBody.append(
                                        "try \(identifier.identifier).\(i).borshEncode(to: &buffer)"
                                    )
                                }
                            } else {
                                // For other types
                                memberSubBody.append(
                                    "try \(identifier.identifier).borshEncode(to: &buffer)")
                            }
                        }

                    }
                    body = body + memberSubBody.reversed()
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
        // Handle enums
        case let enumDecl as EnumDeclSyntax:
            do {
                var body: [String] = []
                var i = 0

                // Loop on each "case" declaration in the enum
                for member in enumDecl.memberBlock.members {
                    guard let caseDecl = member.decl.as(EnumCaseDeclSyntax.self) else { continue }

                    // For each case declaration, loop on its elements (e.g. case A, B)
                    for element in caseDecl.elements {
                        if let parameterClause = element.parameterClause {
                            // If the case has parameters, generate the code as follows
                            var j = 0
                            let parameters = parameterClause.parameters.map {
                                if let tupleType = $0.type.as(TupleTypeSyntax.self) {
                                    let subparams = tupleType.elements.map { _ in
                                        j += 1
                                        return "p\(j)"
                                    }
                                    return "let (\(subparams.joined(separator: ", ")))"
                                } else {
                                    j += 1
                                    return "let p\(j)"
                                }
                            }.joined(separator: ", ")

                            body.append(
                                """
                                case .\(element.name)(\(parameters)): do {
                                    try UInt8(\(i)).borshEncode(to: &buffer)
                                    \((1...j).map { "try p\($0).borshEncode(to: &buffer)" }.joined(separator: "\n"))
                                }
                                """)
                        } else {
                            // If the case has no parameters, generate the code as follows
                            body.append(
                                "case .\(element.name): try UInt8(\(i)).borshEncode(to: &buffer)")
                        }

                        i += 1
                    }
                }

                // Return the generated extension for BorshEncodable
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
        // Throw an error if the macro is applied to an unsupported type
        default:
            throw MacroExpansionErrorMessage(
                "Macro BorshEncodable can only be applied to a struct or enum")
        }
    }
}
