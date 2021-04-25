/*:
 # Animating Objects!
 
 It's boring when things are still. Give them some life with animations! You can easily add an animation with the animation modifier. It works just like in SwiftUI. When the value of another modifier such as opacity, offset or color changes, it will animate that change.

 
 ### How can an object be animated?
 
 To see how this works, we need to know how to modify values in our object.
 
 **First**, just like how SwiftUI includes `@State`, we can use `@State3D` instead before a variable to make sure our object is recreated to represent it's new form when the state value changes.
 
 **Second**, there needs to be a way to modify this state variable. This could be external or could simply be when the object appears. The `onAppear` modifier runs a block of the code when the object is displayed on your screen.
*/

/*:
 Below, you see a new object with a state variable. The object has multiple modifiers applied to it that change depending on if the variable is `true` or `false`. The animation modifier specifies the animation to run when these values change.
 
 **Try modifying the values yourself and tap run my code to see what happens!**
*/
import Swift3D

struct AnimatedObject: Object {
    @State3D private var specialVariable: Bool = true
    
    var object: Object {
        /*#-editable-code*/Box(chamferRadius: 0.1)/*#-end-editable-code*/
            /*#-editable-code*/.opacity(specialVariable ? 0.6 : 1)/*#-end-editable-code*/
            /*#-editable-code*/.offset(x: specialVariable ? 0 : 1)/*#-end-editable-code*/
            /*#-editable-code*/.color(specialVariable ? .green : .red)/*#-end-editable-code*/
            /*#-editable-code*/.animation(.easeInOut)/*#-end-editable-code*/
            .onAppear {
                specialVariable = false
            }
    }
}
/*:
 * Experiment: Try changing the animation to use a different method and add your own duration. Also try making your animation run forever!
 
 + Note: Take a look at the hints in the bottom right of your screen if you need some help.
*/
//#-hidden-code
import SwiftUI
import PlaygroundSupport
struct MainView: View {
    var body: some View {
        Scene3D(baseObject: AnimatedObject(), realisticLighting: false)
            .backgroundImage(UIImage(named: "mainSceneBackground")!)
    }
}

PlaygroundPage.current.setLiveView(MainView())
//#-end-hidden-code
