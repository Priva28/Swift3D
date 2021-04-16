//
//  ContentView.swift
//  blank
//
//  Created by Christian Privitelli on 11/4/21.
//

import SwiftUI

struct obj: Object {
    @State3D var test = false
    
    var object: Object {
        return Stack(.y, spacing: 0) {
            Plane()
                .color(.blue)
            Stack(.x) {
                Box()
                    .color(test ? .red : .white)
                    .offset(x: test ? -1 : 0)
                    .opacity(test ? 1 : 0.5)
                    .animation(Animation3D.easeOut(duration: 5).repeatForever())
                Stack(.y) {
                    Box()
                        .color(.red)
                    Sphere()
                        .onAppear {
                            test.toggle()
                        }
                }
            }
        }
    }
}

struct obj2: Object {
    @State3D var test2 = false
    var attributes: ObjectAttributes = ObjectAttributes()
    var object: Object {
        Stack(.y) {
            Box()
                .color(.red)
            Sphere()
                //.opacity(test2 ? 1 : 0.5)
//                .animation(Animation3D.easeIn(duration: 5))
//                .onAppear {
//                    test2 = true
//                }
        }
    }
}

struct obj3: Object {
    @State3D var test = 0
    var attributes: ObjectAttributes = ObjectAttributes()
    var object: Object {
        Box()
            .chamferRadius(0.1)
            //.offset(x: test == 0 ? 0 : 1)
            .color(test == 0 ? .white : .red)
            .animation(.linear(duration: 3).repeatForever())
            //.opacity(test == 0 ? 0.9 : 1)
            .onAppear {
                test = 3
            }
    }
}

struct TrulyCustomObject: Object {
    @State3D private var specialVariable: Bool = /*#-editable-code*/true/*#-end-editable-code*/
    
    var object: Object {
        ViewPlane(size: CGSize(width: 20, height: 30)) {
            VStack {
                Text("Hello my name is viewplane")
                Spacer()
            }
        }
        .color(.red)
        //Box(size: .init(width: <#T##CGFloat#>, height: <#T##CGFloat#>, length: <#T##CGFloat#>), chamferRadius: <#T##CGFloat#>)
    }
}

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

struct ContentView: View {
    var body: some View {
        Scene3D(baseObject: TwoDInThreeD())
            .backgroundColor(.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
