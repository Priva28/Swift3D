//
//  Animation3D.swift
//  blank
//
//  Created by Christian Privitelli on 15/4/21.
//

import SceneKit
import SwiftUI

public struct Animation3D {
    private init(option: CAMediaTimingFunctionName, duration: Double, repeatForever: Bool = false) {
        self.option = option
        self.duration = duration
        self.repeatForever = repeatForever
    }
    var option: CAMediaTimingFunctionName
    var duration: Double
    var repeatForever: Bool
    enum Options {
        case easeInOut
        case easeIn
        case easeOut
        case linear
    }
    
    // Ease In Out
    public static func easeInOut(duration: Double) -> Animation3D {
        return Animation3D(option: .easeInEaseOut, duration: duration)
    }
    public static var easeInOut: Animation3D { easeInOut(duration: 1) }
    
    // Ease In
    public static func easeIn(duration: Double) -> Animation3D {
        return Animation3D(option: .easeIn, duration: duration)
    }
    public static var easeIn: Animation3D { easeIn(duration: 1) }
    
    // Ease Out
    public static func easeOut(duration: Double) -> Animation3D {
        return Animation3D(option: .easeOut, duration: duration)
    }
    public static var easeOut: Animation3D { easeOut(duration: 1) }
    
    public static func linear(duration: Double) -> Animation3D {
        return Animation3D(option: .linear, duration: duration)
    }
    public static var linear: Animation3D { linear(duration: 1) }
    
    public func repeatForever(autoreverses: Bool = true) -> Animation3D {
        var me = self
        me.repeatForever = true
        return me
    }
}
