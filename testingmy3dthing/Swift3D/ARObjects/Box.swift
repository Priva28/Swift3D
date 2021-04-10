//
//  Box.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 4/4/21.
//

import SceneKit
import Combine

public struct Box: Object {
    public var subject = PassthroughSubject<UUID, Never>()
    
    public var object: Object { self }
    
    public var id = UUID()
    public var attributes = ObjectAttributes()
    
    public let size: Size3D
    public var chamferRadius: CGFloat
    public init(size: Size3D = .init(width: 1, height: 1, length: 1), chamferRadius: CGFloat = 0) {
        self.size = size
        self.chamferRadius = chamferRadius
    }
}

extension Box {
    public func renderScnNode() -> SCNNode {
        var node = SCNNode(geometry: SCNBox(width: size.width, height: size.height, length: size.length, chamferRadius: chamferRadius))
        applyAttributes(to: &node)
        return node
    }
}

extension Box {
    public func chamferRadius(_ radius: CGFloat) -> Box {
        var me = self
        me.chamferRadius = radius
        return me
    }
}
