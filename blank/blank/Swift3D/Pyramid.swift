//
//  Sphere.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 4/4/21.
//

import SceneKit
import Combine

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
        var node = SCNNode(geometry: SCNPyramid(width: size.width, height: size.height, length: size.length))
        
        let changedAttributes = applyAttributes(to: &node)
        return (node, changedAttributes)
    }
}
