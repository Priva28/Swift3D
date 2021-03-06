//
//  ARHelpers.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 4/4/21.
//

import ARKit

public enum XYZ: String {
    case x = "x"
    case y = "y"
    case z = "z"
}

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

extension Location3D {
    public var scnVector3: SCNVector3 {
        return SCNVector3(self.x, self.y, self.z)
    }
}

extension SCNActionTimingMode {
    func caMediaTimingFunction() -> CAMediaTimingFunction {
        switch self {
        case .easeIn:
            return CAMediaTimingFunction(name: .easeIn)
        case .easeInEaseOut:
            return CAMediaTimingFunction(name: .easeInEaseOut)
        case .easeOut:
            return CAMediaTimingFunction(name: .easeOut)
        case .linear:
            return CAMediaTimingFunction(name: .linear)
        default:
            return CAMediaTimingFunction(name: .linear)
        }
    }
}

extension ARSCNView {
    var screenCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
}

func deg2rad(_ number: Float) -> Float {
    return number * .pi / 180
}
