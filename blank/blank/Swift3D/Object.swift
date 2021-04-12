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
    public var id: UUID { UUID() }
}

extension Object {
    public var scnNode: SCNNode {
        let render = renderScnNode()
        render.0.name = id.uuidString
        _ = render.1.compactMap { e in
            switch e {
            case .opacity:
                render.0.name!.append("opacity")
            case .onAppear(let method):
                method()
            default:
                print("fail")
            }
        }
        return render.0
    }
    // THIS IS THE DEFAULT ONLY DONT EXPECT THIS TO APPLY CHANGES TO EVERYTHING AS MOST HAVE CUSTOM IMPLEMENTATIONS
    public func renderScnNode() -> (SCNNode, [Attributes]) {
        let render = object.renderScnNode()
        return render
    }
    public func applyAttributes(to node: inout SCNNode) -> [Attributes] {
        var changedAttributes: [Attributes] = []
        
        if let color = color {
            changedAttributes.append(.color)
            node.geometry?.firstMaterial?.diffuse.contents = UIColor(color)
        }
        
        if let offset = offset {
            changedAttributes.append(.color)
            node.transform = SCNMatrix4MakeTranslation(offset.x, offset.y, offset.z)
        }
        
        if let opacity = opacity {
            changedAttributes.append(.opacity)
            node.opacity = opacity
        }
        
        if let onAppear = onAppear {
            changedAttributes.append(.onAppear(onAppear))
        }
        
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
    func childWithId(uuid: UUID) -> Object? {
        var array: [Object] = []
        var timeout = 0
        if array.isEmpty {
            array.append(self)
        }
        while array.last!.id != uuid {
            array.append(array.last!.object)
            timeout += 1
            if timeout > 1000 {
                print("too many objects to search")
                return nil
            }
        }
        return array.last!
    }
}
