//#-hidden-code
import SwiftUI
import PlaygroundSupport
struct MainView: View {
    var body: some View {
        Scene3D(baseObject: ModifiedObject())
            .backgroundImage(UIImage(named: "page1SceneBackground")!)
    }
}

PlaygroundPage.current.setLiveView(MainView())
//#-end-hidden-code

/*:
 We can customize objects to look and behave however we like with modifiers. Some basic modifiers include `color(_ : Color)`, `offset(_ : Size3D)` and `opacity(_ : CGFloat)`.
 
 Try using them yourself, then tapping run my code to see them work!
 
*/

import Swift3D

struct ModifiedObject: Object {
    var object: Object {
        /*#-editable-code*/Box()/*#-end-editable-code*/
            .color(/*#-editable-code*/.white/*#-end-editable-code*/)
            .offset(Location3D(x: /*#-editable-code*/0/*#-end-editable-code*/, y: /*#-editable-code*/0/*#-end-editable-code*/, z: /*#-editable-code*/0/*#-end-editable-code*/))
    }
}
