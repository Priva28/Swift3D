//
//  Plane.swift
//  blank
//
//  Created by Christian Privitelli on 15/4/21.
//

import SceneKit

public struct Plane: Object {
    public var object: Object { self }
    
    public var attributes = ObjectAttributes()
    
    public let size: CGSize
    public var doubleSided: Bool
    public var vertical: Bool
    public var cornerRadius: CGFloat
    
    public init(size: CGSize = .init(width: 10, height: 10), doubleSided: Bool = true, vertical: Bool = false, cornerRadius: CGFloat = 0) {
        self.size = size
        self.doubleSided = doubleSided
        self.vertical = vertical
        self.cornerRadius = cornerRadius
    }
}

extension Plane {
    public func renderScnNode() -> (SCNNode, [Attributes]) {
        let plane = SCNPlane(width: size.width, height: size.height)
        plane.materials.first?.isDoubleSided = doubleSided
        plane.cornerRadius = cornerRadius
        var node = SCNNode(geometry: plane)
        if !vertical {
            node.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        }
        let changedAttributes = applyAttributes(to: &node)
        return (node, changedAttributes)
    }
}

extension Plane {
    public func doubleSided(_ bool: Bool) -> Plane {
        var me = self
        me.doubleSided = bool
        return me
    }
}

extension Plane {
    public func cornerRadius(_ cornerRadius: CGFloat) -> Plane {
        var me = self
        me.cornerRadius = cornerRadius
        return me
    }
}
