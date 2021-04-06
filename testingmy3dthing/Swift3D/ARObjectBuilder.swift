//
//  ARObjectBuilder.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 4/4/21.
//

@resultBuilder public struct ARObjectBuilder {
    public static func buildBlock() -> [ARObject] {
        return []
    }
    public static func buildBlock(_ object: ARObject...) -> [ARObject] {
        return object
    }
    public static func buildIf(_ object: ARObject?) -> [ARObject] {
        return object == nil ? [] : [object!]
    }
    public static func buildEither(first object: ARObject) -> [ARObject] {
        return [object]
    }
    public static func buildEither(second object: ARObject) -> [ARObject] {
        return [object]
    }
}
