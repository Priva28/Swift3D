//
//  Box.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 4/4/21.
//

import SceneKit
import Combine

public struct Box: Object {
    public var object: Object { self }
    
    public var attributes = ObjectAttributes()
    
    private let size: Size3D
    private var chamferRadius: CGFloat
    public init(size: Size3D = .init(width: 1, height: 1, length: 1), chamferRadius: CGFloat = 0) {
        self.size = size
        self.chamferRadius = chamferRadius
    }
}

extension Box {
    public func renderScnNode() -> (SCNNode, [Attributes]) {
        var node = SCNNode(geometry: SCNBox(width: size.width, height: size.height, length: size.length, chamferRadius: chamferRadius))
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
