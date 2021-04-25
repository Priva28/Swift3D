//
//  Torus.swift
//  blank
//
//  Created by Christian Privitelli on 17/4/21.
//

import SceneKit

public struct Torus: Object {
    public init(ringRadius: CGFloat = 0.5, pipeRadius: CGFloat = 0.2) {
        self.ringRadius = ringRadius
        self.pipeRadius = pipeRadius
    }
    
    public var object: Object { self }
    public var attributes = ObjectAttributes()
    
    private let ringRadius: CGFloat
    private let pipeRadius: CGFloat
}

extension Torus {
    public func renderScnNode() -> (SCNNode, [Attributes]) {
        let torus = SCNTorus(ringRadius: ringRadius, pipeRadius: pipeRadius)
        var node = SCNNode(geometry: torus)
        let changedAttributes = applyAttributes(to: &node)
        return (node, changedAttributes)
    }
}
