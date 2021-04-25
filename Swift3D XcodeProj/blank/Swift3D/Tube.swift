//
//  Tube.swift
//  blank
//
//  Created by Christian Privitelli on 17/4/21.
//

import SceneKit

public struct Tube: Object {
    public init(outerRadius: CGFloat = 0.5, innerRadius: CGFloat = 0.1, height: CGFloat = 1) {
        self.outerRadius = outerRadius
        self.innerRadius = innerRadius
        self.height = height
    }
    
    public var object: Object { self }
    public var attributes = ObjectAttributes()
    
    private let outerRadius: CGFloat
    private let innerRadius: CGFloat
    private let height: CGFloat
}

extension Tube {
    public func renderScnNode() -> (SCNNode, [Attributes]) {
        let torus = SCNTube(innerRadius: innerRadius, outerRadius: outerRadius, height: height)
        var node = SCNNode(geometry: torus)
        let changedAttributes = applyAttributes(to: &node)
        return (node, changedAttributes)
    }
}
