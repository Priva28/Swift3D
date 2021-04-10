import SwiftUI

public struct OrbThingy: View {
    // if anyone at apple is looking at this code... pls make memberwise inits public by default so i dont have to do this every time :)
    public init(
        size: CGFloat, 
        color1: Color, 
        color2: Color, 
        shadow1: Color, 
        shadow2: Color, 
        startPoint: UnitPoint = .top, 
        endPoint: UnitPoint = .bottom
    ) {
        self.size = size
        self.color1 = color1
        self.color2 = color2
        self.shadow1 = shadow1
        self.shadow2 = shadow2
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    private var size: CGFloat
    private var color1: Color
    private var color2: Color
    private var shadow1: Color
    private var shadow2: Color
    private var startPoint: UnitPoint = .top
    private var endPoint: UnitPoint = .bottom
    
    public var body: some View {
        Circle()
            .fill(LinearGradient(
                gradient: Gradient(colors: [color1, color2]),
                startPoint: .top,
                endPoint: .bottom
            ))
            .frame(width: size, height: size)
            .overlay(
                RadialGradient(
                    gradient: Gradient(colors: [.white, Color.white.opacity(0.00001)]),
                    center: .center,
                    startRadius: 0,
                    endRadius: size/6.5
                )
                .blur(radius: size/6)
                .offset(x: -(size/7), y: -(size/7))
            )
            .drawingGroup()
            .innerShadow(
                Circle(),
                upperShadow: Color.white,
                lowerShadow: Color.black,
                spread: size/650,
                radius: size/8
            )
            .shadow(color: shadow1, radius: 5, x: 3, y: 3)
            .shadow(color: shadow2, radius: 6, x: -3, y: -3)
    }
}
