//
//  ContentView.swift
//  blank
//
//  Created by Christian Privitelli on 11/4/21.
//

import SwiftUI

struct obj: Object {
    @State3D var test = false
    var attributes: ObjectAttributes = ObjectAttributes()
    var object: Object {
        Stack(.y) {
            Plane()
                .color(.gray)
            Stack(.x) {
                Box()
                    .color(test ? .red : .white)
                    .offset(z: test ? 1 : 0)
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
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    test = 3
                }
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
