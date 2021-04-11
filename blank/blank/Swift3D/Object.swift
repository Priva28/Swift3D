//
//  Object.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 4/4/21.
//

import SceneKit
import Combine

public protocol Object: ObjectSupportedAttributes, ObjectGroup {
    var object: Object { get }
    var scnNode: SCNNode { get }
    var id: UUID { get }
    var subject: PassthroughSubject<UUID, Never> { get }
    func renderScnNode() -> SCNNode
}

extension Object {
    public var objects: [Object] { [self] }
    public var id: UUID { UUID() }
    public var subject: PassthroughSubject<UUID, Never> { PassthroughSubject<UUID, Never>() }
}

extension Object {
    public var scnNode: SCNNode {
        return renderScnNode()
    }
    public func renderScnNode() -> SCNNode {
        bindProperties()
//        _ = object.subject.sink { sentID in
//            subject.send(sentID)
//        }
        let node = object.renderScnNode()
        node.name = "test"
        return node
    }
    public func applyAttributes(to node: inout SCNNode) {
        if let color = color {
            node.geometry?.firstMaterial?.diffuse.contents = UIColor(color)
        }
        
        let offset = self.offset ?? .zero
        node.transform = SCNMatrix4MakeTranslation(offset.x, offset.y, offset.z)
    }
}

extension Object {
    func bindProperties(_ toSelf: Bool = false) {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if var child = child.value as? DynamicProperty3D {
                child.id = id
                child.subject = subject
            }
        }
    }
}

