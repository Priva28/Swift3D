/*:
 # Bringing 2D Into 3D
 
 Swift3D was created with the future of a world full of 3D and AR(more on that next) in the future. 2D views are still very important in a 3D space and there needs to be a way to incorporate them easily. Swift3D lets you do this!
*/

/*:
 Simply just add a `ViewPlane` to your object. `ViewPlane` takes in a closure that should be a SwiftUI view and creates a plane with that view ontop.
*/
import Swift3D
import SwiftUI

struct TwoDInThreeD: Object {
    var object: Object {
        ViewPlane(vertical: true) {
            //#-editable-code
            VStack {
                Text("This is a 2D SwiftUI view inside a 3D world!")
                    .font(.title)
                    .padding()
                Text("Try adding your own view here!")
            }
            //#-end-editable-code
        }
    }
}
//#-hidden-code
import PlaygroundSupport
struct MainView: View {
    var body: some View {
        Scene3D(baseObject: TwoDInThreeD(), realisticLighting: false)
            .backgroundImage(UIImage(named: "mainSceneBackground")!)
    }
}

PlaygroundPage.current.setLiveView(MainView())
//#-end-hidden-code
