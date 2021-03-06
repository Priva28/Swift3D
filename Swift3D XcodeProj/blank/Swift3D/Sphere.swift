//
//  Sphere.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 4/4/21.
//

import SceneKit

public struct Sphere: Object {
    public init(radius: CGFloat = 0.5) {
        self.radius = radius
    }
    
    public var object: Object { self }
    public var attributes = ObjectAttributes()
    
    private let radius: CGFloat
}

extension Sphere {
    public func renderScnNode() -> (SCNNode, [Attributes]) {
        let sphere = SCNSphere(radius: radius)
        var node = SCNNode(geometry: sphere)
        let changedAttributes = applyAttributes(to: &node)
        return (node, changedAttributes)
    }
}
