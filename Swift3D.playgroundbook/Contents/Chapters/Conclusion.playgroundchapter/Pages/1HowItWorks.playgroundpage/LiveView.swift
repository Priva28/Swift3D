import PlaygroundSupport
import SwiftUI
struct ContentView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
            Image(uiImage: UIImage(named: "protocolDesign")!)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

let vc = UIHostingController(rootView: ContentView())
PlaygroundPage.current.liveView = vc
