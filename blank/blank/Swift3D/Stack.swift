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
            let yTranslation = index == 0 ? 0 : parentNode.boundingBox.max.y + spacing + childNode.boundingBox.max.y
            let zTranslation = index == 0 ? 0 : parentNode.boundingBox.max.z + spacing + childNode.boundingBox.max.z
            switch xyz {
            case .x:
                childNode.position.x += xTranslation
            case .y:
//                print(parentNode.boundingBox.max)
//                print(childNode.boundingBox.max)
                childNode.position.y += yTranslation
            case .z:
                childNode.position.z += zTranslation
            }
            parentNode.addChildNode(childNode)
            //print(parentNode.boundingBox.max)
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
