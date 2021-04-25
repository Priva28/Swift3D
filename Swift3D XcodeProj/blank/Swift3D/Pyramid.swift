//
//  Sphere.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 4/4/21.
//

import SceneKit

public struct Pyramid: Object {
    public init(size: Size3D = Size3D(width: 1, height: 1, length: 1)) {
        self.size = size
    }
    
    public var object: Object { self }
    public var attributes = ObjectAttributes()
    
    private let size: Size3D
}

extension Pyramid {
    public func renderScnNode() -> (SCNNode, [Attributes]) {
        let pyramid = SCNPyramid(width: size.width, height: size.height, length: size.length)
        var node = SCNNode(geometry: pyramid)
        node.position.y = -node.boundingBox.max.y/2
        let containerNode = SCNNode()
        containerNode.addChildNode(node)
        let changedAttributes = applyAttributes(to: &node)
        return (containerNode, changedAttributes)
    }
}
