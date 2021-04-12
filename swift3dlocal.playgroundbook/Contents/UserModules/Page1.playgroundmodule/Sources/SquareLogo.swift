import SwiftUI

struct SquareLogo: View {
    var body: some View {
        ZStack {
            
            square(
                size: 282, 
                cornerRadius: 70, 
                foregroundColor: .init(red: 1, green: 0.13, blue: 0.13)
            )
            .shadow(color: Color.white.opacity(0.7), radius: 23)
            
            square(
                size: 268, 
                cornerRadius: 68, 
                foregroundColor: .init(red: 0.84, green: 0.12, blue: 0.09)
            )
            
            square(
                size: 254, 
                cornerRadius: 66, 
                foregroundColor: .init(red: 0.7, green: 0.1, blue: 0.01)
            )
            
            square(
                size: 240, 
                cornerRadius: 64, 
                foregroundColor: .init(red: 89/255, green: 8/255, blue: 2/255)
            )
            Image(systemName: "swift")
                .resizable()
                .frame(width: 150, height: 150)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.orange)
                .shadow(radius: 18)
        }
        .opacity(0.6)
    }
    
    func square(
        size: CGFloat, 
        cornerRadius: CGFloat, 
        foregroundColor: Color
    ) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .frame(width: size, height: size)
            .foregroundColor(foregroundColor)
            .innerShadow(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous), 
                upperShadow: Color(red: 215/255, green: 200/255, blue: 200/255),
                lowerShadow: Color.black.opacity(70), 
                spread: 0.05, 
                radius: 25
            )
    }
}
