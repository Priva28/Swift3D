//
//  ObjectAttributes.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 4/4/21.
//

import SwiftUI
import SceneKit

public struct ObjectAttributes {
    public var index: Int = 0
    public var color: Color? = nil
    public var offset: Location3D? = nil
    public var opacity: CGFloat? = nil
    public var rotation: Location3D? = nil
    public var animation: Animation3D? = nil
    public var onAppear: (() -> Void)? = nil
    public init() { }
}

public enum Attributes {
    case opacity
    case color
    case offset
    case rotation
    case onAppear(() -> Void)
}

public protocol ObjectSupportedAttributes {
    var attributes: ObjectAttributes { get set }
}

// THIS WILL MEAN CUSTOM VIEWS WONT BE ABLE TO SAVE ATTRIBUTES BUT IT LOOKS CLEANER SO ITS OK FOR NOW.
extension ObjectSupportedAttributes {
    public var attributes: ObjectAttributes { get {ObjectAttributes()} set {} }
}

extension Object {
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
        
        if let rotation = rotation {
            changedAttributes.append(.rotation)
            node.eulerAngles.x = deg2rad(rotation.x)
            node.eulerAngles.y = deg2rad(rotation.y)
            node.eulerAngles.z = deg2rad(rotation.z)
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
    internal var index: Int {
        get {
            return attributes.index
        }
        set {
            attributes.index = newValue
        }
    }
}

extension Object {
    internal var color: Color? {
        get {
            return attributes.color
        }
        set {
            attributes.color = newValue
        }
    }
    public func color(_ color: Color) -> some Object {
        var me = self
        me.attributes.color = color
        return me
    }
}

extension Object {
    internal var offset: Location3D? {
        get {
            return attributes.offset
        }
        set {
            attributes.offset = newValue
        }
    }
    public func offset(_ offset: Location3D) -> some Object {
        var me = self
        me.offset = offset
        return me
    }
    public func offset(x: Float = 0, y: Float = 0, z: Float = 0) -> some Object {
        var me = self
        me.offset = Location3D(x: x + (offset?.x ?? 0), y: y + (offset?.y ?? 0), z: z + (offset?.z ?? 0))
        return me
    }
}

extension Object {
    internal var opacity: CGFloat? {
        get {
            return attributes.opacity
        }
        set {
            attributes.opacity = newValue
        }
    }
    public func opacity(_ opacity: CGFloat) -> some Object {
        var me = self
        me.opacity = opacity
        return me
    }
}

extension Object {
    internal var animation: Animation3D? {
        get {
            return attributes.animation
        }
        set {
            attributes.animation = newValue
        }
    }
    public func animation(_ animation: Animation3D?) -> some Object {
        var me = self
        me.attributes.animation = animation
        return me
    }
}

extension Object {
    internal var rotation: Location3D? {
        get {
            return attributes.rotation
        }
        set {
            attributes.rotation = newValue
        }
    }
    public func rotation(_ rotation: Location3D) -> some Object {
        var me = self
        me.attributes.rotation = rotation
        return me
    }
    public func rotation(x: Float = 0, y: Float = 0, z: Float = 0) -> some Object {
        var me = self
        me.rotation = Location3D(x: x + (rotation?.x ?? 0), y: y + (rotation?.y ?? 0), z: z + (rotation?.z ?? 0))
        return me
    }
}


extension Object {
    internal var onAppear: (() -> Void)? {
        get {
            return attributes.onAppear
        }
        set {
            attributes.onAppear = newValue
        }
    }
    public func onAppear(_ closure: @escaping () -> Void) -> some Object {
        var me = self
        me.onAppear = closure
        return me
    }
}

