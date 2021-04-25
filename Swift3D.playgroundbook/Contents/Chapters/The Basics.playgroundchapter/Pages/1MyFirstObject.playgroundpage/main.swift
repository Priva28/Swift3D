/*:
 
# Let’s get started!

+ Callout(It's all objects...):
  Just like how SwiftUI is all based on views, Swift3D is all based on objects.

 Just like views in SwiftUI, objects should be reusable, modifiable, and easy to combine to create larger, more complex objects. Let's see how you can make your first object.
 
 As you can see below, it's just as easy as creating a SwiftUI view. Try setting your first object to be a `Box()`, `Sphere()`, `Pyramid()` or try finding another object you like then press run my code.
 
*/
import Swift3D

struct MyFirstObject: Object {
    var object: Object {
        /*#-editable-code enter your first object here!*/Box()/*#-end-editable-code*/
    }
}
/*:
First, we import Swift3D. Then we can make a `struct` that conforms to the `Object` protocol. What your object looks like should be declared in the `object` property, just like a SwiftUI views `body`.
*/

/*:
 * Experiment: Try changing the object initialisers to customise things like size, chamfer radius, radius or corner radius.
 
 
 + Note: Take a look at the hints in the bottom right of your screen for some examples.
*/
//#-hidden-code
import SwiftUI
import PlaygroundSupport
struct MainView: View {
    var body: some View {
        Scene3D(baseObject: MyFirstObject(), realisticLighting: false)
            .backgroundImage(UIImage(named: "mainSceneBackground")!)
    }
}
PlaygroundPage.current.setLiveView(MainView())
//#-end-hidden-code
