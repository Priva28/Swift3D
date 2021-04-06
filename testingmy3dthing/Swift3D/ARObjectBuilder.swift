//
//  ARObjectBuilder.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 4/4/21.
//

public protocol ARObjectGroup {
    var objects: [ARObject] { get }
}

extension Array: ARObjectGroup where Element == ARObject {
    public var objects: [ARObject] { self }
}

@resultBuilder public struct ARObjectBuilder {
    public static func buildBlock(_ objects: ARObjectGroup...) -> [ARObject] {
        return objects.flatMap { $0.objects }
    }
    public static func buildOptional(_ object: [ARObjectGroup]?) -> [ARObject] {
        return object?.flatMap { $0.objects } ?? []
    }
    public static func buildEither(first object: [ARObjectGroup]) -> [ARObject] {
        return object.flatMap { $0.objects }
    }
    public static func buildEither(second object: [ARObjectGroup]) -> [ARObject] {
        return object.flatMap { $0.objects }
    }
}
