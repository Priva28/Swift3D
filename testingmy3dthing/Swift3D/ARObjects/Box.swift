//
//  Box.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 4/4/21.
//

import SceneKit
import Combine

public struct Box: ARObject {
    public var subject = PassthroughSubject<UUID, Never>()
    
    public var object: ARObject { self }
    
    public var id = UUID()
    public var attributes = ARObjectAttributes()
    
    public let size: ARSize
    public let chamferRadius: CGFloat
    public init(size: ARSize, chamferRadius: CGFloat = 0) {
        self.size = size
        self.chamferRadius = chamferRadius
    }
}

extension Box {
    public func renderScnNode() -> SCNNode {
        let node = SCNNode(geometry: SCNBox(width: size.width, height: size.height, length: size.length, chamferRadius: chamferRadius))
        if let color = color {
            node.geometry?.firstMaterial?.diffuse.contents = UIColor(color)
        }
        let offset = offset ?? .zero
        node.transform = SCNMatrix4MakeTranslation(offset.x, offset.y, offset.z)
        return node
    }
}


