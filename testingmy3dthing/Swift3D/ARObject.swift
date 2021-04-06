//
//  ARObject.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 4/4/21.
//

import SceneKit

public protocol ARObject: ARObjectSupportedAttributes {
    init()
    var object: ARObject { get }
    var scnNode: SCNNode { get }
    var id: UUID { get }
}

public class ARNode {
    public init(object: ARObject) {
        self.object = object
        self.scnNode = object.scnNode
    }
    var object: ARObject
    var scnNode: SCNNode
    func didSet() {
        self.scnNode = setScnNode()
    }
    func setScnNode() -> SCNNode {
        return object.scnNode
    }
}

extension ARObject {
    public var scnNode: SCNNode { scnNodeManager.scnNode }
    public var scnNodeManager: ARNode { ARNode(object: self) }
    public func renderScnNode() -> SCNNode { object.scnNode }
}

extension ARObject {
    init() {
        self.init()
        bindProperties(scnNodeManager.didSet)
    }
    func bindProperties(_ didSet: @escaping () -> Void) {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if var child = child.value as? ARDynamicProperty {
                child.update = didSet
            }
        }
    }
}
