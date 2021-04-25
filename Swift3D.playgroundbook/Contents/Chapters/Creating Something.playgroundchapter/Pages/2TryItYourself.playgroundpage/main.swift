/*:

### Using inspiration from the last page or your own idea try creating your own object!
 
*/
import Swift3D
import SwiftUI

//#-editable-code
struct YourObject: Object {
    var object: Object {
    }
}
//#-end-editable-code

struct ContentView: View {
    var body: some View {
        //#-editable-code
        ARScene3D(baseObject: YourObject())
        //#-end-editable-code
    }
}

//#-hidden-code
import PlaygroundSupport
PlaygroundPage.current.setLiveView(ContentView())
//#-end-hidden-code
