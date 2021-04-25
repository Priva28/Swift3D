//
//  Capsule.swift
//  blank
//
//  Created by Christian Privitelli on 17/4/21.
//

import SceneKit

public struct Capsule: Object {
    public init(capRadius: CGFloat = 0.2, height: CGFloat = 1) {
        self.capRadius = capRadius
        self.height = height
    }
    
    public var object: Object { self }
    public var attributes = ObjectAttributes()
    
    private let capRadius: CGFloat
    private let height: CGFloat
}

extension Capsule {
    public func renderScnNode() -> (SCNNode, [Attributes]) {
        let capsule = SCNCapsule(capRadius: capRadius, height: height)
        var node = SCNNode(geometry: capsule)
        let changedAttributes = applyAttributes(to: &node)
        return (node, changedAttributes)
    }
}
