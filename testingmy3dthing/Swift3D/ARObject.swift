//
//  ARObject.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 4/4/21.
//

import SceneKit
import Combine

public protocol ARObject: ARObjectSupportedAttributes, ARObjectGroup {
    var object: ARObject { get }
    var scnNode: SCNNode { get }
    var id: UUID { get }
    var subject: PassthroughSubject<UUID, Never> { get }
    func renderScnNode() -> SCNNode
}

extension ARObject {
    public var objects: [ARObject] { [self] }
}

extension ARObject {
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
}

extension ARObject {
    func bindProperties(_ toSelf: Bool = false) {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if var child = child.value as? ARDynamicProperty {
                child.id = id
                child.subject = subject
            }
        }
    }
}

