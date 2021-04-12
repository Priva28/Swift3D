//#-hidden-code
import SwiftUI
import PlaygroundSupport
struct MainView: View {
    var body: some View {
        Scene3D(baseObject: MyFirstObject())
            .backgroundImage(UIImage(named: "page1SceneBackground")!)
    }
}
PlaygroundPage.current.setLiveView(MainView())
//#-end-hidden-code

/*:
 
# Let’s get started!

+ Callout(It's all objects...):
  Just like how SwiftUI is all based on views, I have based Swift3D all on objects.

Just like views in SwiftUI, objects should be reusable, modifiable and easy to combine to create larger, more complex objects. Let's see how you can make your first object.
 
 As you can see below, it's just as easy as creating a SwiftUI view. Try setting your first object a `Box()`, `Sphere()` or `Pyramid()` then press run my code.
 
*/

import Swift3D

struct MyFirstObject: Object {
    var object: Object {
        /*#-editable-code enter your first object here!*/Box()/*#-end-editable-code*/
    }
}

/*:
First, we import Swift3D. Then we can make a `struct` that conforms to the `Object` protocol. What your object looks like should be declared in the `object` property, just like a SwiftUI view `body`. 
*/
