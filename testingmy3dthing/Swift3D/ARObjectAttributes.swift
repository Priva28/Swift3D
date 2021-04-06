//
//  ARObjectAttributes.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 4/4/21.
//

import SwiftUI

public struct ARObjectAttributes {
    public var color: Color? = nil
    public var offset: ARLocation? = nil
}

public protocol ARObjectSupportedAttributes {
    var attributes: ARObjectAttributes { get set }
}

extension ARObject {
    public var color: Color? {
        get {
            return attributes.color
        }
        set {
            attributes.color = newValue
        }
    }
    public func color(_ color: Color) -> some ARObject {
        var me = self
        me.attributes.color = color
        return me
    }
}

extension ARObject {
    public var offset: ARLocation? {
        get {
            return attributes.offset
        }
        set {
            attributes.offset = newValue
        }
    }
    public func offset(_ offset: ARLocation) -> some ARObject {
        var me = self
        me.offset = offset
        return me
    }
    public func offset(x: Float = 0, y: Float = 0, z: Float = 0) -> some ARObject {
        var me = self
        me.offset = ARLocation(x: x, y: y, z: z)
        return me
    }
}

extension ARObject {
    public func onAppear(_ closure: () -> Void) -> some ARObject {
        closure()
        return self
    }
}
