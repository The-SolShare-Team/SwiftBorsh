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
                                for (i, type) in tupleType.elements.enumerated().reversed() {
                                    memberSubBody.append(
                                        "self.\(identifier.identifier).\(i) = try \(type.type.trimmed)(fromBorshBuffer: &buffer)"
                                    )
                                }
                            } else {
                                // For other types
                                memberSubBody.append(
                                    "self.\(identifier) = try \(annotation.trimmed)(fromBorshBuffer: &buffer)"
                                )
                            }
                        }

                    }
                    body = body + memberSubBody.reversed()
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
        case let enumDecl as EnumDeclSyntax:
            do {
                var body: [String] = []
                var i = 0

                for member in enumDecl.memberBlock.members {
                    guard let caseDecl = member.decl.as(EnumCaseDeclSyntax.self) else { continue }
                    for element in caseDecl.elements {
                        if let parameterClause = element.parameterClause {
                            let parameters = parameterClause.parameters.map {
                                let labelPrefix = $0.firstName.map { "\($0): " } ?? ""
                                if let tupleType = $0.type.as(TupleTypeSyntax.self) {
                                    let subparams = tupleType.elements.map {
                                        return "try \($0.type.trimmed)(fromBorshBuffer: &buffer)"
                                    }
                                    return labelPrefix + "(\(subparams.joined(separator: ", ")))"
                                } else {
                                    return labelPrefix
                                        + "try \($0.type.trimmed)(fromBorshBuffer: &buffer)"
                                }
                            }.joined(separator: ", ")

                            body.append(
                                """
                                case \(i): self = .\(element.name)(\(parameters))
                                """)
                        } else {
                            body.append("case \(i): self = .\(element.name)")
                        }

                        i += 1
                    }
                }

                return [
                    try ExtensionDeclSyntax(
                        """
                        extension \(type.trimmed): BorshDecodable {
                            public init(fromBorshBuffer buffer: inout BorshByteBuffer) throws(BorshDecodingError) {
                                let variant = try UInt8(fromBorshBuffer: &buffer)
                                switch variant {
                                \(raw: body.joined(separator: "\n"))
                                default: throw BorshDecodingError.invalidValue
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
