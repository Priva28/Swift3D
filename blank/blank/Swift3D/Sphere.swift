//
//  Sphere.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 4/4/21.
//

import SceneKit
import Combine

public struct Sphere: Object {
    public var subject = PassthroughSubject<UUID, Never>()
    
    public var object: Object { self }
    
    public var id = UUID()
    public var attributes = ObjectAttributes()
    
    public let radius: CGFloat
    public init(radius: CGFloat) { self.radius = radius }
}

extension Sphere {
    public func renderScnNode() -> (SCNNode, [Attributes]) {
        var node = SCNNode(geometry: SCNSphere(radius: radius))
        let changedAttributes = applyAttributes(to: &node)
        return (node, changedAttributes)
    }
}
