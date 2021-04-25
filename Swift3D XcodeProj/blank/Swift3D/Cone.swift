//
//  Cone.swift
//  blank
//
//  Created by Christian Privitelli on 17/4/21.
//

import SceneKit

public struct Cone: Object {
    public init(topRadius: CGFloat = 0, bottomRadius: CGFloat = 0.5, height: CGFloat = 1) {
        self.topRadius = topRadius
        self.bottomRadius = bottomRadius
        self.height = height
    }
    
    public var object: Object { self }
    public var attributes = ObjectAttributes()
    
    private let topRadius: CGFloat
    private let bottomRadius: CGFloat
    private let height: CGFloat
}

extension Cone {
    public func renderScnNode() -> (SCNNode, [Attributes]) {
        let cone = SCNCone(topRadius: topRadius, bottomRadius: bottomRadius, height: height)
        var node = SCNNode(geometry: cone)
        let changedAttributes = applyAttributes(to: &node)
        return (node, changedAttributes)
    }
}

