// Code from https://github.com/costachung/neumorphic
// License is at the bottom of the file.

import SwiftUI

extension View {
    func inverseMask<Mask: View>(_ mask: Mask) -> some View {
        self.mask(
            mask
                .foregroundColor(.black)
                .background(Color.white)
                .compositingGroup()
                .luminanceToAlpha()
        )
    }
}

private struct SoftInnerShadowViewModifier<S: Shape> : ViewModifier {
    var shape: S
    var upperShadow : Color = .black
    var lowerShadow : Color = .white
    var spread: CGFloat = 0.5    //The value of spread is between 0 to 1. Higher value makes the shadow look more intense.
    var radius: CGFloat = 10
    
    init(shape: S, upperShadow: Color, lowerShadow: Color, spread: CGFloat, radius:CGFloat) {
        self.shape = shape
        self.upperShadow = upperShadow
        self.lowerShadow = lowerShadow
        self.spread = spread
        self.radius = radius
    }
    
    fileprivate func strokeLineWidth(_ geo: GeometryProxy) -> CGFloat {
        return geo.size.width * 0.10
    }
    
    fileprivate func strokeLineScale(_ geo: GeometryProxy) -> CGFloat {
        let lineWidth = strokeLineWidth(geo)
        return geo.size.width / CGFloat(geo.size.width - lineWidth)
    }
    
    fileprivate func shadowOffset(_ geo: GeometryProxy) -> CGFloat {
        return (geo.size.width <= geo.size.height ? geo.size.width : geo.size.height) * 0.5 * min(max(spread, 0), 1)
    }
    
    
    fileprivate func addSoftInnerShadow(_ content: SoftInnerShadowViewModifier.Content) -> some View {
        return GeometryReader { geo in
            
            self.shape.fill(self.lowerShadow)
                .inverseMask(
                    self.shape
                        .offset(x: -self.shadowOffset(geo), y: -self.shadowOffset(geo))
                )
                .offset(x: self.shadowOffset(geo) , y: self.shadowOffset(geo))
                .blur(radius: self.radius)
                .shadow(color: self.lowerShadow, radius: self.radius, x: -self.shadowOffset(geo)/2, y: -self.shadowOffset(geo)/2 )
                .mask(
                    self.shape
                )
                .overlay(
                    self.shape
                        .fill(self.upperShadow)
                        .inverseMask(
                            self.shape
                                .offset(x: self.shadowOffset(geo), y: self.shadowOffset(geo))
                        )
                        .offset(x: -self.shadowOffset(geo) , y: -self.shadowOffset(geo))
                        .blur(radius: self.radius)
                        .shadow(color: self.upperShadow, radius: self.radius, x: self.shadowOffset(geo)/2, y: self.shadowOffset(geo)/2 )
                )
                .mask(
                    self.shape
                )
        }
    }
    
    func body(content: Content) -> some View {
        content.overlay(
            addSoftInnerShadow(content)
        )
    }
}


//For more readable, we extend the View and create a softInnerShadow function.
extension View {
    public func innerShadow<S : Shape>(
        _ content: S, 
        upperShadow: Color = .black, 
        lowerShadow: Color = Color.white.opacity(0.7), 
        spread: CGFloat = 0.1, 
        radius: CGFloat = 10
    ) -> some View {
        modifier(
            SoftInnerShadowViewModifier(
                shape: content, 
                upperShadow: upperShadow, 
                lowerShadow: lowerShadow, 
                spread: spread, 
                radius: radius
            )
        )
    }
}

/*
 MIT License
 
 Copyright (c) 2020 Costa Chung
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

