//
//  ARHelpers.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 4/4/21.
//

import SceneKit

public struct ARSize {
    public var width: CGFloat
    public var height: CGFloat
    public var length: CGFloat
}

public struct ARLocation {
    public var x: Float
    public var y: Float
    public var z: Float
    
    static public var zero: ARLocation {
        return ARLocation(x: 0, y: 0, z: 0)
    }
}
