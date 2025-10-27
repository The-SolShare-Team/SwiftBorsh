# SwiftBorsh

An implementation of [**B**inary **O**bject **R**epresentation **S**erializer for **H**ashing](https://borsh.io/) in Swift.

There is much room for improvement performance-wise, in way of reducing copies.

This library includes macros for automatic conformance to BorshCodable. They ought to be considered experimental. Please report any types for which they do not generate correct implementations. Nested tuples are known to be currently unsupported.