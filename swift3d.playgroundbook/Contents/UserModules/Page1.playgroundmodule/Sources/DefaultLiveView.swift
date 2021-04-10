import SwiftUI

public struct DefaultLiveView: View {
    @State var orb: Bool = false
    public init() {
        self._orb = State(initialValue: false)
    }
    public var body: some View {
        ZStack {
            Image(uiImage: #imageLiteral(resourceName: "meshGradientBackground.png"))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .saturation(1.1)
                .brightness(-0.13)
            VStack {
                SquareLogo()
                    .padding(30)
                Rectangle()
                    .frame(width: 300, height: 30)
                    .foregroundColor(.white)
                    .opacity(1)
                    .blur(radius: 15)
                    .mask(
                        Text("Swift3D")
                            .bold()
                            .font(.largeTitle)
                    )
                    .scaleEffect(1.1)
                Rectangle()
                    .frame(width: 400, height: 30)
                    .foregroundColor(.white)
                    .opacity(1)
                    .blur(radius: 10)
                    .mask(
                        Text("A 3D framework for everyone.")
                            .font(.title)
                    )
            }
            .offset(y: -20)
            
            OrbThingy(
                size: 38,
                color1:  .init(red: 253/255, green: 171/255, blue: 179/255),
                color2:  .init(red: 255/255, green: 097/255, blue: 146/255),
                shadow1: .init(red: 1, green: 124/255, blue: 137/255),
                shadow2: .init(red: 1, green: 132/255, blue: 137/255)
            )
            .offset(x: -162, y: -240)
            .offset(y: orb ? 15 : 0)
            
            OrbThingy(
                size: 76,
                color1:  .init(red: 250/255, green: 170/255, blue: 192/255),
                color2:  .init(red: 155/255, green: 163/255, blue: 249/255),
                shadow1: .init(red: 119/255, green: 110/255, blue: 255/255),
                shadow2: Color.white.opacity(0.3)
            )
            .offset(x: 185, y: 262)
            .offset(y: orb ? 8 : 0)
            
            OrbThingy(
                size: 53,
                color1:  .init(red: 130/255, green: 167/255, blue: 250/255),
                color2:  .init(red: 249/255, green: 137/255, blue: 146/255),
                shadow1: .init(red: 175/255, green: 124/255, blue: 137/255),
                shadow2: .clear
            )
            .offset(x: 150, y: 230)
            .offset(y: orb ? 12 : 0)
            
            
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                orb.toggle()
            }
        }
    }
}
