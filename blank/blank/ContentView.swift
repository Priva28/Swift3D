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
        return Stack(.y) {
            Plane()
                .color(.gray)
            Stack(.x) {
                Box()
                    .color(test ? .red : .white)
                    .offset(x: test ? -1 : 0)
                    .opacity(test ? 1 : 0.5)
                    .animation(Animation3D.easeOut(duration: 5).repeatForever())
                Sphere()
                    .opacity(test ? 1 : 0.1)
                    .onAppear {
                        test = true
                    }
            }
        }
    }
}

struct obj2: Object {
    var attributes: ObjectAttributes = ObjectAttributes()
    var object: Object {
        Stack(.y) {
            Box()
            Box()
        }
    }
}

struct obj3: Object {
    @State3D var test = 0
    var attributes: ObjectAttributes = ObjectAttributes()
    var object: Object {
        Box()
            .offset(x: test == 0 ? 0 : 1)
            .color(test == 0 ? .white : .red)
            .animation(.linear(duration: 3).repeatForever())
            .opacity(test == 0 ? 0.9 : 1)
            .onAppear {
                test = 3
            }
    }
}

struct ContentView: View {
    var body: some View {
        Scene3D(baseObject: obj())
            .backgroundColor(.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
