//
//  Box.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 4/4/21.
//

import SceneKit

public struct Box: Object {
    public init(size: Size3D = .init(width: 1, height: 1, length: 1), chamferRadius: CGFloat = 0) {
        self.size = size
        self.chamferRadius = chamferRadius
    }
    
    public var object: Object { self }
    public var attributes = ObjectAttributes()
    
    private let size: Size3D
    private var chamferRadius: CGFloat
}

extension Box {
    public func renderScnNode() -> (SCNNode, [Attributes]) {
        let box = SCNBox(width: size.width, height: size.height, length: size.length, chamferRadius: chamferRadius)
        var node = SCNNode(geometry: box)
        let changedAttributes = applyAttributes(to: &node)
        return (node, changedAttributes)
    }
}

extension Box {
    public func chamferRadius(_ radius: CGFloat) -> Box {
        var me = self
        me.chamferRadius = radius
        return me
    }
}
