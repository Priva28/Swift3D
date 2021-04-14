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

public enum Attributes {
    case opacity
    case color
    case offset
    case onAppear(() -> Void)
}

extension Object {
    public var objects: [Object] { [self] }
}

extension Object {
    public var id: String {
        if self is Stack || object is Stack {
            let stack = self as? Stack ?? self.object as! Stack
            var base = "Stack,\(stack.xyz.rawValue),\(stack.spacing ?? 0),"
            if color != nil || object.color != nil { base.append("color") }
            if offset != nil || object.offset != nil { base.append("offset") }
            if opacity != nil || object.opacity != nil { base.append("opacity") }
            return base + ",\(String(format: "%04d", index))"
        } else {
            var base = "\(type(of: self)),"
            if color != nil || object.color != nil { base.append("color") }
            if offset != nil || object.offset != nil { base.append("offset") }
            if opacity != nil || object.opacity != nil { base.append("opacity") }
            return base + ",\(String(format: "%04d", index))"
        }
    }
}

//extension Object {
//    public func withAnimation(_ animation: Animation3D, body: @escaping () -> Void) {
//        body()
//        let mirror = Mirror(reflecting: self)
//        for child in mirror.children {
//            if let child = child.value as? DynamicProperty3D {
//                child.update()
//            }
//        }
//    }
//}

//extension Object {
//    public func repeatingForever(body: @escaping () -> Void, delay: CGFloat = 1) {
//        DispatchQueue.ma
//    }
//}

extension Object {
    public var scnNode: SCNNode {
        let render = renderScnNode()
        _ = render.1.compactMap {
            switch $0 {
            case .onAppear(let function):
                // please don't judge me i didn't have the time to implement this properly and i'm assuming it would have appeared at least 1.5 second after this
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
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
        return object.renderScnNode()
    }
    
    public func applyAttributes(to node: inout SCNNode) -> [Attributes] {
        var changedAttributes: [Attributes] = []
        
        if let color = color {
            changedAttributes.append(.color)
            node.geometry?.firstMaterial?.diffuse.contents = UIColor(color)
        }
        
        if let offset = offset {
            changedAttributes.append(.offset)
            node.position.x = node.position.x + offset.x
            node.position.y = node.position.y + offset.y
            node.position.z = node.position.z + offset.z
        }
        
        if let opacity = opacity {
            changedAttributes.append(.opacity)
            node.opacity = opacity
        }
        
        if let onAppear = onAppear {
            changedAttributes.append(.onAppear(onAppear))
        }
        
        node.name = id
        
        return changedAttributes
    }
}

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
            if timeout > 1000 {
                print("too many objects to search")
                return nil
            }
        }
        return array.first { $0.id == id }
    }
}
