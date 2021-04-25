//
//  Cylinder.swift
//  blank
//
//  Created by Christian Privitelli on 17/4/21.
//

import SceneKit

public struct Cylinder: Object {
    public init(radius: CGFloat = 0.5, height: CGFloat = 1) {
        self.radius = radius
        self.height = height
    }
    
    public var object: Object { self }
    public var attributes = ObjectAttributes()
    
    private let radius: CGFloat
    private let height: CGFloat
}

extension Cylinder {
    public func renderScnNode() -> (SCNNode, [Attributes]) {
        let cylinder = SCNCylinder(radius: radius, height: height)
        var node = SCNNode(geometry: cylinder)
        let changedAttributes = applyAttributes(to: &node)
        return (node, changedAttributes)
    }
}
