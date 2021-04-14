//
//  ContentView.swift
//  blank
//
//  Created by Christian Privitelli on 11/4/21.
//

import SwiftUI

struct obj: Object {
    @State3D var test = 0
    var attributes: ObjectAttributes = ObjectAttributes()
    var object: Object {
        Stack(.x) {
            Box(chamferRadius: 0.1)
                .color(.red)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        test = 3
                    }
                }
            Stack(.y, spacing: 0.2) {
                Box()
                Sphere()
                Pyramid()
                    .offset(y: -0.5)
                    //.offset(y: 1)
                    .offset(x: test == 0 ? 0 : 1)
                    //.offset(y: test == 0 ? 0 : 1)
                    .offset(z: test == 0 ? 0 : 1)
            }
            .offset(y: test == 0 ? 0 : 0.5)
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
