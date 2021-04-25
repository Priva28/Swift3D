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
    var id: String { get }
    func renderScnNode() -> (SCNNode, [Attributes])
}

extension Object {
    public var objects: [Object] { [self] }
}

// MARK: - Rendering of objects into SCNNode.

extension Object {
    public var scnNode: SCNNode {
        let render = renderScnNode()
        _ = render.1.compactMap {
            switch $0 {
            case .onAppear(let function):
                // please don't judge me i didn't have the time to implement this properly and i'm assuming it would have appeared at least 0.8 seconds after this
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    function()
                }
            default:
                break
            }
        }
        return render.0
    }
    
    // THIS IS THE DEFAULT ONLY DONT EXPECT THIS TO APPLY CHANGES TO EVERYTHING AS MOST HAVE CUSTOM IMPLEMENTATIONS
    public func renderScnNode() -> (SCNNode, [Attributes]) {
        let render = object.renderScnNode()
        var node = render.0
        var changedAttributes = applyAttributes(to: &node)
        changedAttributes.append(contentsOf: render.1)
        return (node, changedAttributes)
    }
}

// MARK: - Bind properties of @State3D to scene update method.

extension Object {
    func bindProperties(_ update: @escaping () -> Void) {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if var child = child.value as? DynamicProperty3D {
                child.update = update
            }
        }
    }
}

// MARK: - Search for child object with id.

extension Object {
    func childWithId(id: String) -> Object? {
        var array: [Object] = []
        var timeout = 0
        if array.isEmpty {
            array.append(self)
        }
        while !array.contains(where: { $0.id == id }) {
            switch array.last! {
            case is Stack:
                let stack = array.last! as! Stack
                for object in stack.content {
                    array.append(object)
                }
            default:
                array.append(array.last!.object)
            }
            timeout += 1
            if timeout > 500 {
                print("too many objects to search")
                return nil
            }
        }
        return array.first { $0.id == id }
    }
}

// MARK: - Getter for id.

extension Object {
    public var id: String {
        if self is Stack || object is Stack {
            let stack = self as? Stack ?? self.object as! Stack
            var base = "Stack,\(stack.xyz.rawValue),\(stack.spacing ?? 0),"
            if color != nil || object.color != nil { base.append("color") }
            if offset != nil || object.offset != nil { base.append("offset") }
            if opacity != nil || object.opacity != nil { base.append("opacity") }
            if rotation != nil || object.rotation != nil { base.append("rotation") }
            return base + ",\(String(format: "%04d", index))"
        } else {
            var base = "\(type(of: self)),"
            if color != nil || object.color != nil { base.append("color") }
            if offset != nil || object.offset != nil { base.append("offset") }
            if opacity != nil || object.opacity != nil { base.append("opacity") }
            if rotation != nil || object.rotation != nil { base.append("rotation") }
            return base + ",\(String(format: "%04d", index))"
        }
    }
}
