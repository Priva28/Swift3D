//
//  XStack.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 4/4/21.
//

import SwiftUI
import SceneKit
import Combine

public struct Stack: Object {
    public var object: Object { self }
    
    public var attributes = ObjectAttributes()
    
    public var content: [Object]
    public var xyz: XYZ
    public var spacing: Float?
    
    public init(_ xyz: XYZ, spacing: Float? = nil, @ObjectBuilder content: () -> [Object]) {
        self.xyz = xyz
        self.spacing = spacing
        
        var objects: [Object] = []
        for (index, i) in content().enumerated() {
            var object = i
            object.index = index
            objects.append(object)
        }
        
        self.content = objects
    }
}

extension Stack {
    func stackToNode(xyz: XYZ, spacing: Float?, color: Color?) -> SCNNode {
        let parentNode = SCNNode()
        
        for (index, object) in content.enumerated() {
            let childNode = object.scnNode
            let spacing = spacing ?? 0
            let xTranslation = index == 0 ? 0 : parentNode.boundingBox.max.x + spacing + childNode.boundingBox.max.x
            let yTranslation = index == 0 ? 0 : parentNode.boundingBox.min.y + spacing + childNode.boundingBox.min.y
            let zTranslation = index == 0 ? 0 : parentNode.boundingBox.max.z + spacing + childNode.boundingBox.max.z
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
    public func renderScnNode() -> (SCNNode, [Attributes]) {
        var node = stackToNode(xyz: xyz, spacing: spacing, color: color)
        let changedAttributes = applyAttributes(to: &node)
        return (node, changedAttributes)
    }
}

public enum XYZ: String {
    case x = "x"
    case y = "y"
    case z = "z"
}
