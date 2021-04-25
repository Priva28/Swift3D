/*:
 # Stacks!
 
 This is useless, you might say. It's just basic shapes with simple modifications, right? And you would be right. But with the power of Swift, making stacks of objects is easy, with simple declarations.

Swift3D uses `Stack` to combine objects into one single object. A stack can be in the `x`, `y`, or `z` axis.
 
Try doing it yourself below. Set the axis you want to make the stack in and the objects you want to combine.
*/
import Swift3D

struct TrulyCustomObject: Object {
    var object: Object {
        Stack(/*#-editable-code*/.x/*#-end-editable-code*/) {
            /*#-editable-code*/Box()/*#-end-editable-code*/
            /*#-editable-code*/Box()/*#-end-editable-code*/
        }
    }
}
/*:
 + Experiment: Try changing the spacing between object in the stack.
 
 * Callout(Fun Fact:):
Stacks work because of the new `@resultBuilder` (aka `@functionBuilder`) feature in Swift 5. It lets you return *something* from a list of declarations. In this case `Stack` works by taking in an axis as well as an array of Objects constructed with an `@ObjectBuilder`. This is similar to how SwiftUI uses `@ViewBuilder` to construct views from its stacks, groups and more.
*/
//#-hidden-code
import SwiftUI
import PlaygroundSupport
struct MainView: View {
    var body: some View {
        Scene3D(baseObject: TrulyCustomObject(), realisticLighting: false)
            .backgroundImage(UIImage(named: "mainSceneBackground")!)
    }
}

PlaygroundPage.current.setLiveView(MainView())
//#-end-hidden-code
