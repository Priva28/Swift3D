//
//  XStack.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 4/4/21.
//

import SwiftUI
import SceneKit
import Combine

public struct Stack: ARObject {
    public var subject = PassthroughSubject<UUID, Never>()
    public var object: ARObject { self }
    public var id = UUID()
    public var attributes = ARObjectAttributes()
    
    public var content: [ARObject]
    public var xyz: XYZ
    public var spacing: Float?
    
    public init(_ xyz: XYZ, spacing: Float? = nil, @ARObjectBuilder content: () -> [ARObject]) {
        self.xyz = xyz
        self.spacing = spacing
        self.content = content()
    }
}

extension Stack {
    func stackToNode(xyz: XYZ, content: [ARObject], spacing: Float?, color: Color?) -> SCNNode {
        guard let firstInContent = content.first else { return SCNNode() }
        let parentNode = firstInContent.scnNode
        if firstInContent.color == nil {
            if let color = color {
                parentNode.geometry?.firstMaterial?.diffuse.contents = UIColor(color)
            }
        }
        for object in content where object.id != firstInContent.id {
            let childNode = object.scnNode
            let spacing = spacing ?? 0
            let xTranslation = parentNode.boundingBox.max.x + spacing + childNode.boundingBox.max.x
            let yTranslation = parentNode.boundingBox.min.y + spacing + childNode.boundingBox.min.y
            let zTranslation = parentNode.boundingBox.max.z + spacing + childNode.boundingBox.max.z
            if object.color == nil {
                if let color = color {
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIColor(color)
                }
            }
            switch xyz {
            case .x:
                childNode.transform = SCNMatrix4Translate(childNode.transform, xTranslation, 0, 0)
            case .y:
                childNode.transform = SCNMatrix4Translate(childNode.transform, 0, yTranslation, 0)
            case .z:
                childNode.transform = SCNMatrix4Translate(childNode.transform, 0, 0, zTranslation)
            }
            parentNode.addChildNode(childNode)
        }
        return parentNode
    }
}

extension Stack {
    public func renderScnNode() -> SCNNode {
        let node = stackToNode(xyz: xyz, content: content, spacing: spacing, color: color)
        let offset = offset ?? .zero
        node.transform = SCNMatrix4MakeTranslation(offset.x, offset.y, offset.z)
        return node
    }
}

public enum XYZ {
    case x
    case y
    case z
}
