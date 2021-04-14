//
//  ObjectAttributes.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 4/4/21.
//

import SwiftUI

public struct ObjectAttributes {
    public var index: Int = 0
    public var color: Color? = nil
    public var offset: Location3D? = nil
    public var opacity: CGFloat? = nil
    public var onAppear: (() -> Void)? = nil
    public init() { }
}

public protocol ObjectSupportedAttributes {
    var attributes: ObjectAttributes { get set }
}

extension ObjectSupportedAttributes {
    //public var attributes: ObjectAttributes { get {ObjectAttributes()} set {} }
}

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
        me.offset = Location3D(x: x, y: y, z: z)
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
