//
//  Sphere.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 4/4/21.
//

import SceneKit
import Combine

public struct Pyramid: Object {
    public var subject = PassthroughSubject<UUID, Never>()
    
    public var object: Object { self }
    
    public var id = UUID()
    public var attributes = ObjectAttributes()
    
    public let size: Size3D
    public init(size: Size3D = Size3D(width: 1, height: 1, length: 1)) { self.size = size }
}

extension Pyramid {
    public func renderScnNode() -> (SCNNode, [Attributes]) {
        var node = SCNNode(geometry: SCNPyramid(width: size.width, height: size.height, length: size.length))
        let changedAttributes = applyAttributes(to: &node)
        return (node, changedAttributes)
    }
}
