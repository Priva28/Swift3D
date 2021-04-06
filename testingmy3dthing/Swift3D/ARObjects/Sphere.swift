//
//  Sphere.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 4/4/21.
//

import SceneKit
import Combine

public struct Sphere: ARObject {
    public var subject = PassthroughSubject<UUID, Never>()
    
    public var object: ARObject { self }
    
    public var id = UUID()
    public var attributes = ARObjectAttributes()
    
    public let radius: CGFloat
    public init(radius: CGFloat) { self.radius = radius }
}

extension Sphere {
    public func renderScnNode() -> SCNNode {
        let node = SCNNode(geometry: SCNSphere(radius: radius))
        if let color = color {
            node.geometry?.firstMaterial?.diffuse.contents = UIColor(color)
        }
        let offset = offset ?? .zero
        node.transform = SCNMatrix4MakeTranslation(offset.x, offset.y, offset.z)
        return node
    }
}
