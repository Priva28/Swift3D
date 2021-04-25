//
//  ObjectBuilder.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 4/4/21.
//

public protocol ObjectGroup {
    var objects: [Object] { get }
}

extension Array: ObjectGroup where Element == Object {
    public var objects: [Object] { self }
}

@_functionBuilder public struct ObjectBuilder {
    public static func buildBlock(_ objects: ObjectGroup...) -> [Object] {
        return objects.flatMap { $0.objects }
    }
    public static func buildOptional(_ object: [ObjectGroup]?) -> [Object] {
        return object?.flatMap { $0.objects } ?? []
    }
    public static func buildEither(first object: [ObjectGroup]) -> [Object] {
        return object.flatMap { $0.objects }
    }
    public static func buildEither(second object: [ObjectGroup]) -> [Object] {
        return object.flatMap { $0.objects }
    }
}
