/*:
 # Interation with SwiftUI
 
 You can bring your custom 3D objects into a 2D application with `Scene3D` and `ARScene3D`. These views take in your base custom object and will automatically configure lighting, camera and more for you.
 
 Try turning `Scene3D` below into the AR version, `ARScene3D`, then set `realisticLighting` to `true` and run it to see your object in the real world!
*/
import Swift3D
import SwiftUI

struct RandomObject: Object {
    var object: Object {
        //#-editable-code
        Stack(.y) {
            Box()
                .color(.red)
            Sphere()
                .color(.blue)
        }
        //#-end-editable-code
    }
}

struct ContentView: View {
    var body: some View {
        //#-editable-code
        Scene3D(baseObject: RandomObject(), realisticLighting: false)
        //#-end-editable-code
    }
}
//#-hidden-code
import PlaygroundSupport

PlaygroundPage.current.setLiveView(ContentView())
//#-end-hidden-code
