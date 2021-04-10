//
//  ARHelpers.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 4/4/21.
//

import SceneKit

public struct Size3D {
    public init(width: CGFloat, height: CGFloat, length: CGFloat) {
        self.width = width
        self.height = height
        self.length = length
    }
    
    public var width: CGFloat
    public var height: CGFloat
    public var length: CGFloat
}

public struct Location3D {
    public init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    public var x: Float
    public var y: Float
    public var z: Float
    
    static public var zero: Location3D {
        return Location3D(x: 0, y: 0, z: 0)
    }
}
