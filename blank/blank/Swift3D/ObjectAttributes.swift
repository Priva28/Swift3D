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
    public var animation: Animation3D? = nil
    //public var modifyForever: (() -> Void)? = nil
    public var onAppear: (() -> Void)? = nil
    public init() { }
}

public protocol ObjectSupportedAttributes {
    var attributes: ObjectAttributes { get set }
}

extension ObjectSupportedAttributes {
    public var attributes: ObjectAttributes { get {ObjectAttributes()} set {} }
}

//extension Object {
//    public var modifyForever: (() -> Void)? {
//        get {
//            return attributes.modifyForever
//        }
//        set {
//            attributes.modifyForever = newValue
//        }
//    }
//    public func modifyForever<V>(value: inout State3D<V>, from: V, to: V) -> some Object {
//        var me = self
//        me.attributes.modifyForever = {
//            value.wrappedValue = to
//            DispatchQueue.main.asyncAfter(deadline: .now() + (attributes.animation?.duration ?? 1)) {
//                value.wrappedValue = from
//                _ = modifyForever(value: &value, from: from, to: to)
//            }
//        }
//        return me
//    }
//}

extension Object {
    public var index: Int {
        get {
            return attributes.index
        }
        set {
            attributes.index = newValue
        }
    }
}

extension Object {
    public var color: Color? {
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
    public var offset: Location3D? {
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
    public var opacity: CGFloat? {
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
    public var animation: Animation3D? {
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
    public var onAppear: (() -> Void)? {
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
